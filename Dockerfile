FROM ancine/rh_eap7

ENV BPMS_DEPLOYABLE jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip
ENV BPMS_PATCH jboss-bpmsuite-6.4.5-patch.zip
ENV BPMS_DEPLOYABLE_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAABN7bVXl_29Fpfasv9KvZsa/jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip?dl=1
ENV BPMS_PATCH_URL https://www.dropbox.com/sh/c13togkkp9fq80f/AAAOgTnXojQ6XtbP0ge9XkzQa/jboss-bpmsuite-6.4.5-patch.zip?dl=1


USER jboss
RUN curl -O -J -L $BPMS_DEPLOYABLE_URL \
    && curl -O -J -L $BPMS_PATCH_URL \
    && ln -s $JBOSS_HOME ~/jboss-eap-7.0 \
    && unzip -qo /opt/jboss/$BPMS_DEPLOYABLE \
    && unzip -qo /opt/jboss/$BPMS_PATCH \
    && cd ~/jboss-bpmsuite-6.4.5-patch && ./apply-updates.sh $JBOSS_HOME eap7.x \
    && rm -rf /opt/jboss/$BPMS_DEPLOYABLE /opt/jboss/$BPMS_PATCH /opt/jboss/jboss-bpmsuite-6.4.5-patch

EXPOSE 8080 9990

CMD ["/opt/jboss/jboss/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
