FROM ancine/rh_eap7

ENV EAP_HOME /opt/jboss/eap
ENV BPMS_DEPLOYABLE jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip
ENV BPMS_PATCH jboss-bpmsuite-6.4.4-patch.zip
ENV BPMS_DEPLOYABLE_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAABN7bVXl_29Fpfasv9KvZsa/jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip?dl=1
ENV BPMS_PATCH_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAB-WiTtQXf5zj-4rXwfUijva/jboss-bpmsuite-6.4.4-patch.zip?dl=1


USER jboss
RUN curl -O -J -L $BPMS_DEPLOYABLE_URL \
    && curl -O -J -L $BPMS_PATCH_URL \
    && ln -s $EAP_HOME ~/jboss-eap-7.0 \
    && unzip -qo /opt/jboss/$BPMS_DEPLOYABLE \
    && unzip -qo /opt/jboss/$BPMS_PATCH \
    && cd ~/jboss-bpmsuite-6.4.4-patch && ./apply-updates.sh $EAP_HOME eap7.x \
    && rm -rf /opt/jboss/$BPMS_DEPLOYABLE /opt/jboss/$BPMS_PATCH /opt/jboss/jboss-bpmsuite-6.4.4-patch

EXPOSE 8080 9990

CMD ["/opt/jboss/eap/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
