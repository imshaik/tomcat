#!/usr/bin/env groovy

import hudson.model.*
/*import hudson.EnvVars
import groovy.json.JsonSlurperClassic
import groovy.json.JsonBuilder
import groovy.json.JsonOutput
import java.net.URL*/

@Library('pipeline-groovy')
import com.imran.jenkins.GitPipelineSteps
import com.imran.jenkins.DockerPipelineSteps


properties([
      //buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '1'))
      buildDiscarder(logRotator(artifactNumToKeepStr: '1'))
      //pipelineTriggers([[$class:"SCMTrigger", scmpoll_spec:"H/15 * * * *"]]),
        ])

try {
    //agent { label 'docker' } we can use this as well
    node('Docker')
    {
        //branch name from Jenkins environment variables
            echo "Branch selected is: ${env.BRANCH_NAME}"
            echo "Build number is: ${env.BUILD_NUMBER}"

                def Git            = new GitPipelineSteps(steps);
                def Docker         = new DockerPipelineSteps(steps);

                def reponame       = "tomcat"
                def dockerreponame = "tomcat"
                def githuburl      = "https://github.com/imshaik/${reponame}.git"
                def dockerurl      = "https://hub.docker.com/r/shaikimranashrafi/${dockerreponame}"
                def buildlabel     = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
		def mavenimage     = docker.image("shaikimranashrafi/maven:latest")
		//def sonarimage   = docker.image("shaikimranashrafi/sonarqube:latest")

        stage('Clean workspace')
        {
        /*Cleans the workspace
        */
            deleteDir()
        }

        stage('Clone repository')
	{
           // git branch: "${env.BRANCH_NAME}", credentialsId: 'Github', url: "https://github.com/imshaik/${reponame}.git"

                Git.checkout(githuburl, env.BRANCH_NAME);
                gitHead = Git.commit();
        }

	stage('Build the artifact with pom.xml')
        {
            Docker.mavenbuild( 
		"clean verify package",
		/*" -DbambooPlanRepositoryBranch=${env.BRANCH_NAME}" +
 		" -DbaimbooBuildNumber=${env.BUILD_NUMBER}" +
 		" -Dgit.branch=${env.BRANCH_NAME}" +
 		" -Dgit.commit=${gitCommit}" +
 		" -Dbuild.label=${env.BRANCH_NAME}-B${env.BUILD_NUMBER}",*/
 		"**/target/surefire-reports/*.xml"
		);
        }

	stage('Sonarqube Analysis') {
		Docker.sonar(
			"sonar:sonar"
		     /*	" -Dbuild.label=${projDtrRepo}:${buildLabel}" +
			" -DbambooPlanRepositoryBranch=${env.BRANCH_NAME}" +
			" -DbambooBuildNumber=${env.BUILD_NUMBER}" */
		        );
	}

        stage('Check if dockerfile is exist or not')
        {
            fileExists 'docker/Dockerfile'
        }
        stage ('Build Docker image and push to docker Hub')
        {
            //dir('docker') {

               // def dockerimage = docker.build("shaikimranashrafi/${dockerreponame}:${buildlabel}").push()
	def dockerimage = docker.build("shaikimranashrafi/${dockerreponame}:${buildlabel}", "-f docker/Dockerfile target").push()
                 /* We can also push the image with passing tag name
                dockerimage.push('latest') */

                      // }
        }

        stage ('Run the test on dockerfile')
        {
                sh '''
			Rspec.image.id=$(docker images -q shaikimranashrafi/${dockerreponame}:${buildlabel})
			sed -i -e 's/image.id/${Rspec.image.id}/g' ./spec/tomcat/*.rb
			bundle exec rake spec 2> /dev/null''' 
		//sh("bundle exec rake spec 2> /dev/null")
        }

        stage('Remove local images & containers')
        {
                /*remove docker images locally
                echo "Removing the image shaikimranashrafi/${dockerreponame}:${buildlabel}"
                sh("docker rmi -f shaikimranashrafi/${dockerreponame}:${buildlabel}")*/
		
		// Remove created docker image locally
                Docker.RemoveImage(dockerreponame, buildlabel);

                //Remove docker images which doesnot have a name assigned '<none>' basically
		Docker.RemoveNoneImage();

                //Remove docker containers the one rakefile created
                Docker.RemoveContainer();
        }

        stage ('Archive the .txt artifacts')
        {
            archiveArtifacts artifacts: 'target/*.war', fingerprint: true
        }
   }
}

catch (exc)
{
    echo "Caught: ${exc}"

    String recipient = 'shaik.imran@lowes.com'

    mail subject: "${env.JOB_NAME} (${env.BUILD_NUMBER}) failed",
            body: "It appears that ${env.BUILD_URL} is failing, somebody should do something about that",
              to: recipient,
         replyTo: recipient,
            from: 'noreply@ci.jenkins.io'

    /* Rethrow to fail the Pipeline properly */
    throw exc
}
