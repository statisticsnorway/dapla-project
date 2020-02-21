FROM google/cloud-sdk:281.0.0-alpine

RUN apk --update add openjdk11-jre
RUN gcloud components install pubsub-emulator beta --quiet

VOLUME /data

ENTRYPOINT ["gcloud", "beta", "emulators", "pubsub"]
CMD ["start", "--project=dapla", "--host-port=0.0.0.0:8538", "--data-dir=/data"]