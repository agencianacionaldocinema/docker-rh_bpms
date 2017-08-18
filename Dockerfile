FROM ancine/rh_eap7

ENV EAP_HOME /opt/jboss/eap
ENV BPMS_DEPLOYABLE=jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip
ENV BPMS_PATCH=jboss-bpmsuite-6.4.4-patch.zip
ENV BPMS_DEPLOYABLE_URL=https://www.dropbox.com/sh/c13togkkp9fq80f/AAABN7bVXl_29Fpfasv9KvZsa/jboss-bpmsuite-6.4.0.GA-deployable-eap7.x.zip?dl=1
ENV BPMS_PATCH_URL=https://www.dropbox.com/sh/c13togkkp9fq80f/AAB-WiTtQXf5zj-4rXwfUijva/jboss-bpmsuite-6.4.4-patch.zip?dl=1

USER 1000

RUN curl -O -J -L $BPMS_DEPLOYABLE_URL \
    && curl -O -J -L $BPMS_PATCH_URL \
    && ln -s $EAP_HOME ~/jboss-eap-7.0 \
    && unzip -qo /opt/jboss/$BPMS_DEPLOYABLE \
    && unzip -qo /opt/jboss/$BPMS_PATCH \
    && cd ~/jboss-bpmsuite-6.4.4-patch && ./apply-updates.sh $EAP_HOME eap7.x \
    && rm -rf /opt/jboss/$BPMS_DEPLOYABLE /opt/jboss/$BPMS_PATCH /opt/jboss/jboss-bpmsuite-6.4.4-patch

# Copy demo and support files
COPY support/repositorio-local-niogit $EAP_HOME/bin/.niogit
# USER root
# RUN rm -rf $BPMS_HOME/bin/.niogit/ancine.git && git clone --bare http://192.168.21.46/ancine/sin-bpm.git $BPMS_HOME/bin/.niogit/ancine.git
USER 1000

RUN $EAP_HOME/bin/add-user.sh -a -r ApplicationRealm -u admin -p ancine1! -ro analyst,admin,user,manager,taskuser,reviewerrole,employeebookingrole,kie-server,rest-all --silent
RUN $EAP_HOME/bin/add-user.sh -a -r ApplicationRealm -u controllerUser -p "controllerUser1234;" -ro kie-server,rest-all --silent
COPY support/standalone.xml $EAP_HOME/standalone/configuration/

USER root
RUN chown -R 1000:1000 $EAP_HOME/bin/.niogit $EAP_HOME/standalone/configuration/standalone.xml 

EXPOSE 8001 8080 9990

CMD ["/opt/jboss/eap/bin/standalone.sh","-c","standalone.xml","-b", "0.0.0.0","-bmanagement","0.0.0.0"]
