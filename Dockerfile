FROM maven AS buildstage 
RUN mkdir /opt/project-2-cicd
WORKDIR /opt/project-2-cicd
COPY . .
RUN mvn clean install ###########---> *.war


FROM tomcat 
WORKDIR webapps
COPY --from=buildstage /opt/project-2-cicd/target/*.war .
RUN rm -rf ROOT && mv *.war ROOT.war
EXPOSE 8080
