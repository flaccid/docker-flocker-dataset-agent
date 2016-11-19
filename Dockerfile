FROM flaccid/flocker

ENV FLOCKER_CONTROL_HOST flocker-control
ENV FLOCKER_DATASET_BACKEND aws
ENV AWS_REGION us-east-1
ENV AWS_AVAILABILITY_ZONE us-east-1a

RUN mkdir -p /etc/flocker /usr/local/bin

COPY entry.sh /usr/local/bin/entry.sh

ENTRYPOINT ["/usr/local/bin/entry.sh"]

CMD ["flocker-dataset-agent"]
