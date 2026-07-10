#!/bin/bash

# Configuration with date-based paths
EXECUTION_TIME=$(date +%s)
MAVEN_ROOT_DIR="/var/run/maven"
MAVEN_JSON_FILE="$MAVEN_ROOT_DIR/result.json"
MAVEN_CENTRAL_URL="https://central.sonatype.com/artifact"

if [ $# -eq 0 ]; then
    echo "No packages specified. Nothing to do."
    exit 0
fi

# Initialize files with execution info
mkdir -p "$MAVEN_ROOT_DIR"
cat > "$MAVEN_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "dependencies": []
}
EOF

# Dependency download function
download_dependency() {
    local start_time=$(date +%s)
    # Parse groupId:artifactId:version
    IFS=':' read -ra DEP_PARTS <<< "$dep"
    local groupId=${DEP_PARTS[0]}
    local artifactId=${DEP_PARTS[1]}
    local version=${DEP_PARTS[2]}

    local dep=$1
    local log="$MAVEN_ROOT_DIR/$artifactId.log"

    mvn dependency:get \
        -DgroupId="$groupId" \
        -DartifactId="$artifactId" \
        -Dversion="$version" \
        -Dpackaging="pom" \
        -Dtransitive=false \
        >> "$log" 2>&1

    local status=$?
    local url="\"\""
    if [ $status -eq 0 ]; then
        url="\"$MAVEN_CENTRAL_URL/${groupId//./\/}/$artifactId\""
    fi

    local end_time=$(date +%s)
    local duration=$(( end_time - start_time ))

    # Build dependency JSON entry
    json_dependencies+="$(cat <<EOF
    {
      "package": "$artifactId",
      "version": "$version",
      "status": "$([ $status -eq 0 ] && echo "success" || echo "failed")",
      "duration": $duration,
      "log": "$log",
      "url": $url
    },
EOF
)"
}

# Process all dependencies
for dep in "$@"; do
    [[ -z "$dep" || "$dep" =~ ^# ]] && continue
    download_dependency "$dep"
done

# Write final JSON file
json_dependencies=${json_dependencies%,}
cat > "$MAVEN_JSON_FILE" <<EOF
{
  "startTime": $EXECUTION_TIME,
  "input": "$@",
  "dependencies": [
$json_dependencies
  ],
  "endTime": $(date +%s)
}
EOF
