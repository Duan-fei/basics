FROM registry.cn-beijing.aliyuncs.com/shannonai/golang:v2.0.1 AS builder

ARG PROJ_NAME="ldap-api"
ARG SSH_KEY
RUN mkdir -p /root/go/src/$PROJ_NAME
COPY . src/$PROJ_NAME
RUN $GOPATH/bin/download_dependency.sh $SSH_KEY \
    && tput setaf 2; echo "output:" $(which $PROJ_NAME); tput setaf 7
RUN go get -u github.com/go-swagger/go-swagger/cmd/swagger
RUN cd /root/go/src/ldap-api/ \
    && swagger generate spec -o swagger.yaml

# ---
FROM registry.cn-beijing.aliyuncs.com/shannonai/debian:v1.1.0
LABEL maintainer="fei_duan@shannonai.com"

WORKDIR /home/work

COPY --from=builder /root/go/bin/ldap-api ldap-api
COPY --from=builder /root/go/src/ldap-api/swagger.yaml swagger.yaml
COPY entrypoint.sh entrypoint.sh
COPY conf/ /home/work/conf/
RUN mkdir logs assets
RUN chown -R work:work /home/work
RUN chmod u+x ldap-api
RUN chmod u+x entrypoint.sh

USER work
EXPOSE 8080
VOLUME /home/work/logs
VOLUME /home/work/assets

ENTRYPOINT ["./entrypoint.sh"]
CMD ["ldap-api"] # set default arg for entrypoint
