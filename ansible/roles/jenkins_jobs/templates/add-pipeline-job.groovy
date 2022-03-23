/* Adds a multibranch pipeline job to jenkins
The internet doesn't seem to like this approach. Apparently I should use the DSL plugin.
The Jenkins internal API is what we are using here, and it works just fine except docs
are hard to come by.

I manually configured the job as I wanted, then ran: 

java -jar jenkins-cli.jar -auth admin:secret -s https://localhost:8443/ -noCertificateCheck get-job Cloudy-cron > /tmp/Cloudy-cron.xml

The output of that is used to work out what Java stuff I needed to create here.
*/
import hudson.util.PersistedList
import jenkins.model.Jenkins
import jenkins.branch.*
import com.igalg.jenkins.plugins.multibranch.buildstrategy.*
import jenkins.plugins.git.*
import org.jenkinsci.plugins.workflow.multibranch.*
import org.jenkinsci.plugins.workflow.job.WorkflowJob
import org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition
import hudson.model.StringParameterDefinition;
import com.cloudbees.hudson.plugins.folder.computed.*

// Bring some values in from ansible using the jenkins_script modules wierd "args" approach (these are not gstrings)
String folderName = "$folderName"
String jobName = "$jobName"
String gitRepo = "$gitRepo"

Jenkins jenkins = Jenkins.instance // saves some typing

// Get the folder where this job should be
def folder = jenkins.getItem(folderName)
// Create the folder if it doesn't exist
if (folder == null) {
  folder = jenkins.createProject(Folder.class, folderName)
}

// Workflow Job
WorkflowJob pipeline  

Item item = folder.getItem(jobName)
if ( item != null ) {
  // Update case
  pipeline = (WorkflowJob) item
} else {
  // Create case
  pipeline = folder.createProject(WorkflowJob.class, jobName)
}

pipeline.addProperty(new ParametersDefinitionProperty(new StringParameterDefinition("branch", "main","branch to deploy")));
// Configure pipeline script
pipeline.setDefinition(new CpsFlowDefinition( """\
        pipeline {
            agent any
            
            options {
                disableConcurrentBuilds()
            }
            environment {
                def serviceName = ''; 
                def repoName = '';
                def branchName = '';
                def commitID = '';
                def versionName = '';
                def imageName = '';
            }
            stages {
                stage('Init') {
                    steps {
                        script {
                            echo 'Get repository'
                            checkout changelog: false, scm: [\$$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'git_key', url: '${gitRepo}']]]
                        }
                        
                    }
                }
                stage('deploy') {
                    steps {
                        script {
                            echo 'deploy service'
                            sh \"helm upgrade -i ${jobName} helm-charts/${jobName} --set image.tag=\$${branch}\"
                        }
                    }
                }
            }
        }""".stripIndent(), true));
