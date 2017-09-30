FROM ancine/rh_eap7

ENV BUSINESS_CENTRAL_DISTRIBUTION_ZIP "jboss-bpmsuite-7.0.0.Beta01-business-central-eap7.zip" 
ENV KIE_EXECUTION_SERVER_ZIP jboss-brms-bpmsuite-7.0.0.Beta01-execution-server-ee7.zip
ENV BUSINESS_CENTRAL_DISTRIBUTION_ZIP_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAAUxLABzHz5rKu-nwni22RZa/jboss-bpmsuite-7.0.0.Beta01-business-central-eap7.zip?dl=1
ENV KIE_EXECUTION_SERVER_ZIP_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AACEV-iwvRVq5w8-5DhonadIa/jboss-brms-bpmsuite-7.0.0.Beta01-execution-server-ee7.zip?dl=1

USER jboss
RUN curl -O -J -L $BUSINESS_CENTRAL_DISTRIBUTION_ZIP_URL \
    && curl -O -J -L $KIE_EXECUTION_SERVER_ZIP_URL \
    &&  ln -s $JBOSS_HOME ~/jboss-eap-7.0 \
    && unzip -qo /opt/jboss/$BUSINESS_CENTRAL_DISTRIBUTION_ZIP \
    && unzip -qo /opt/jboss/$KIE_EXECUTION_SERVER_ZIP \
    && cp -a /opt/jboss/jboss-brms-bpmsuite-7.0-execution-server-ee7/kie-execution-server.war $JBOSS_HOME/standalone/deployments/ \
    && cp -a /opt/jboss/jboss-brms-bpmsuite-7.0-execution-server-ee7/SecurityPolicy $JBOSS_HOME/bin \
    && touch $JBOSS_HOME/standalone/deployments/kie-execution-server.war.dodeploy \
    && rm -rf /opt/jboss/$BUSINESS_CENTRAL_DISTRIBUTION_ZIP /opt/jboss/jboss-brms-bpmsuite-7.0.0.Beta01-execution-server-ee7*

EXPOSE 8080 9990

CMD ["/opt/jboss/jboss/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
