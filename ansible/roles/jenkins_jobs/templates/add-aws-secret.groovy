import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl
import org.jenkinsci.plugins.plaincredentials.StringCredentials

// parameters
def jenkinsAwsKeyParameters = [
  description:  '${description}',
  id:           '${name}',
  accessKey:       '${accessKey}',
  secKey:     '${secKey}',
]

// get Jenkins instance
Jenkins jenkins = Jenkins.getInstance()

// get credentials domain
def domain = Domain.global()

// get credentials store
def store = jenkins.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

// define secret
def awsSecret = new AWSCredentialsImpl(
  CredentialsScope.GLOBAL,
  jenkinsAwsKeyParameters.id,
  jenkinsAwsKeyParameters.accessKey,
  jenkinsAwsKeyParameters.secKey,
  jenkinsAwsKeyParameters.description
)

// add credential to store
store.addCredentials(domain, awsSecret)

// save to disk
jenkins.save()
