# Quick reference

- The offical OPEA docker images

- Maintained by: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative)

- Where to get help: [openEuler CloudNative SIG](https://gitee.com/openeuler/cloudnative), [openEuler](https://gitee.com/openeuler/community)

# OPEA | openEuler

Current OPEA docker images are built on the [openEuler](https://repo.openeuler.org/)⁠. This repository is free to use and exempted from per-user rate limits.

OPEA is an open platform project that lets you create open, multi-provider, robust, and composable GenAI solutions that harness the best innovation across the ecosystem.

The OPEA platform includes:

- Detailed framework of composable building blocks for state-of-the-art generative AI systems including LLMs, data stores, and prompt engines

- Architectural blueprints of retrieval-augmented generative AI component stack structure and end-to-end workflows

- A four-step assessment for grading generative AI systems around performance, features, trustworthiness, and enterprise-grade readiness

Read more about OPEA at [opea.dev](https://opea.dev/) and explore the OPEA technical documentation at [opea-project.github.io](https://opea-project.github.io/)

# Supported tags and respective Dockerfile links

The tag of each AgentQnA docker image is consist of the version of AgentQnA and the version of basic image. The details are as follows

| Tags | Currently |  Architectures|
|--|--|--|
|[1.2-oe2403lts](https://gitee.com/openeuler/openeuler-docker-images/blob/master/AI/opea/agent/1.2/24.03-lts/Dockerfile)| AgentQnA 1.2 on openEuler 24.03-LTS | amd64 |

# Usage

This example showcases a hierarchical multi-agent system for question-answering applications. The architecture diagram is shown below. 
The supervisor agent interfaces with the user and dispatch tasks to two worker agents to gather information and come up with answers. 
The worker RAG agent uses the retrieval tool to retrieve relevant documents from the knowledge base (a vector database). 
The worker SQL agent retrieve relevant data from the SQL database. 
Although not included in this example, but other tools such as a web search tool or a knowledge graph query tool can be used by the supervisor agent to gather information from additional sources.

Quick Start Deployment Steps:

1. Set up the environment variables.
2. Run Docker Compose.
3. Consume the AgentQnA Service.

### Quick Start: 1.Setup Environment Variable

To set up environment variables for deploying AgentQnA services, follow these steps:

1. Set the required environment variables:

   ```bash
   # Example: host_ip="192.168.1.1"
   export host_ip="External_Public_IP"
   # Example: no_proxy="localhost, 127.0.0.1, 192.168.1.1"
   export no_proxy="Your_No_Proxy"
   export HUGGINGFACEHUB_API_TOKEN="Your_Huggingface_API_Token"
   ```

2. If you are in a proxy environment, also set the proxy-related environment variables:

   ```bash
   export http_proxy="Your_HTTP_Proxy"
   export https_proxy="Your_HTTPs_Proxy"
   ```

### Quick Start: 2.Deploy the Retrieval Tool

First, launch the mega-service.

> Get `launch_retrieval_tool.sh` here: [GenAIExamples](https://github.com/opea-project/GenAIExamples.git)

```bash
cd $WORKDIR/GenAIExamples/AgentQnA/retrieval_tool
bash launch_retrieval_tool.sh
```

Then, ingest data into the vector database. Here we provide an example. 
You can ingest your own data.

```bash
bash run_ingest_data.sh
```

### QuickStart: 3.Prepare SQL Database 

In this example, we will use the Chinook SQLite database. 
Run the commands below.

```bash
# Download data
cd $WORKDIR
git clone https://github.com/lerocha/chinook-database.git
cp chinook-database/ChinookDatabase/DataSources/Chinook_Sqlite.sqlite $WORKDIR/GenAIExamples/AgentQnA/tests/
```

### QuickStart: 4.Launch other tools

In this example, we will use some of the mock APIs provided in the Meta CRAG KDD Challenge to demonstrate the benefits of gaining additional context from mock knowledge graphs.

```bash
docker run -d -p=8080:8000 docker.io/aicrowd/kdd-cup-24-crag-mock-api:v0
```