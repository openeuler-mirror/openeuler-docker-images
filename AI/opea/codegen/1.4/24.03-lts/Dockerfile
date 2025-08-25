ARG BASE_TAG=1.4
FROM openeuler/comps-base:$BASE_TAG-oe2403lts

ARG BASE_TAG
ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b v$BASE_TAG $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/CodeGen/codegen.py $HOME/codegen.py && \
    rm -rf GenAIExamples


ENTRYPOINT ["python", "codegen.py"]