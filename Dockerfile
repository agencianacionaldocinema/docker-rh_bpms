FROM ancine/rh_eap7

ENV BUSINESS_CENTRAL_DISTRIBUTION_ZIP "jboss-bpmsuite-7.0-business-central-eap7.zip" 
ENV KIE_EXECUTION_SERVER_ZIP jboss-bpmsuite-7.0.0.LA.Beta02-execution-server-ee7.zip
ENV BUSINESS_CENTRAL_DISTRIBUTION_ZIP_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAAuMRtXOzZ2IHt8dsKPB3yqa/jboss-bpmsuite-7.0-business-central-eap7.zip?dl=1
ENV KIE_EXECUTION_SERVER_ZIP_URL ftp://partners.redhat.com/3d1161392f9f66565c0bd664c920896e/BPMSuite-7.0.0-Beta02/jboss-bpmsuite-7.0.0.LA.Beta02-execution-server-ee7.zip
ENV CASE_MGMT_WAR_URL=http://repository.jboss.org/nexus/content/groups/public-jboss/org/jbpm/jbpm-wb-case-mgmt-showcase/7.3.0.Final/jbpm-wb-case-mgmt-showcase-7.3.0.Final-wildfly10.war
ENV H2_WAR_URL=https://www.dropbox.com/sh/c13togkkp9fq80f/AADODuQyNlTXK6H6LKc9IgZDa/h2console.war?dl=1

ENV SRC_DIR=/opt/jboss/src
ENV DATA_DIR /opt/jboss/data
RUN mkdir -p $SRC_DIR $DATA_DIR

USER jboss
RUN curl -O -J -L $BUSINESS_CENTRAL_DISTRIBUTION_ZIP_URL \
    && curl -O -J -L $KIE_EXECUTION_SERVER_ZIP_URL \
    && curl -J -L $CASE_MGMT_WAR_URL -o /opt/jboss/jboss/standalone/deployments/jbpm-casemgmt.war \
    && curl -J -L $H2_WAR_URL -o $JBOSS_HOME/standalone/deployments/h2console.war 

RUN ln -s $JBOSS_HOME ~/jboss-eap-7.0 \
    && unzip -qo /opt/jboss/$BUSINESS_CENTRAL_DISTRIBUTION_ZIP \
    && unzip -qo /opt/jboss/$KIE_EXECUTION_SERVER_ZIP \
    && cp -a /opt/jboss/jboss-bpmsuite-7.0-execution-server-ee7/kie-execution-server.war $JBOSS_HOME/standalone/deployments/ \
    && cp -a /opt/jboss/jboss-bpmsuite-7.0-execution-server-ee7/SecurityPolicy $JBOSS_HOME/bin \
    && touch $JBOSS_HOME/standalone/deployments/kie-execution-server.war.dodeploy \
    && rm -rf /opt/jboss/$BUSINESS_CENTRAL_DISTRIBUTION_ZIP /opt/jboss/jboss-brms-bpmsuite-7.0.0.Beta01-execution-server-ee7*

USER root
RUN yum install -y git \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && curl -sSL http://archive.apache.org/dist/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz | tar xzf - -C /usr/share \
    && mv /usr/share/apache-maven-3.2.5 /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    && mkdir /opt/jboss/.m2 \
    && chown -R jboss:jboss $JBOSS_HOME/standalone/configuration/standalone-full.xml \
    /opt/jboss/.m2 \
    $DATA_DIR 
USER jboss

VOLUME $DATA_DIR
VOLUME /opt/jboss/.m2

EXPOSE 8080 9990

CMD ["/opt/jboss/jboss/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
