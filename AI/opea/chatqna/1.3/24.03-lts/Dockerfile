ARG IMAGE_REPO=openeuler
ARG BASE_TAG=1.3
FROM $IMAGE_REPO/comps-base:$BASE_TAG-oe2403lts

ARG BASE_TAG

ARG GENAIEXAMPLES_REPO=https://github.com/opea-project/GenAIExamples.git
RUN git clone -b v$BASE_TAG $GENAIEXAMPLES_REPO && \
    cp -r GenAIExamples/ChatQnA/chatqna.py $HOME/chatqna.py && \
    cp -r GenAIExamples/ChatQnA/entrypoint.sh $HOME/entrypoint.sh && \
    rm -rf GenAIExamples

ENTRYPOINT ["bash", "entrypoint.sh"]