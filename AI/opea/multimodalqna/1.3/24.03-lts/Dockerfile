
ARG BASE_TAG=1.3
FROM openeuler/comps-base:$BASE_TAG-oe2403lts

ARG BASE_TAG

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b v$BASE_TAG $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/MultimodalQnA/multimodalqna.py $HOME/multimodalqna.py && \
    rm -rf GenAIExamples

ENTRYPOINT ["python", "multimodalqna.py"]