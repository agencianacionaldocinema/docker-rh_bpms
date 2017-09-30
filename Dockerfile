FROM ancine/rh_eap7

ENV BUSINESS_CENTRAL_DISTRIBUTION_ZIP "jboss-bpmsuite-7.0.0.Beta01-business-central-eap7.zip" 
ENV BUSINESS_CENTRAL_DISTRIBUTION_ZIP_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAAUxLABzHz5rKu-nwni22RZa/jboss-bpmsuite-7.0.0.Beta01-business-central-eap7.zip?dl=1

USER jboss
RUN curl -O -J -L $BUSINESS_CENTRAL_DISTRIBUTION_ZIP_URL \
    && ln -s $JBOSS_HOME ~/jboss-eap-7.0 \
    && unzip -qo /opt/jboss/$BUSINESS_CENTRAL_DISTRIBUTION_ZIP \
    && rm -rf /opt/jboss/$BUSINESS_CENTRAL_DISTRIBUTION_ZIP

EXPOSE 8080 9990

CMD ["/opt/jboss/jboss/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
