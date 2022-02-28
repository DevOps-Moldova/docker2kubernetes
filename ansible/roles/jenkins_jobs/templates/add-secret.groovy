import jenkins.model.*
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.plugins.credentials.CredentialsScope
import com.cloudbees.plugins.credentials.common.StandardCertificateCredentials
import com.cloudbees.plugins.credentials.domains.Domain
// import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
def domain = Domain.global()
def instance = Jenkins.instance
def credstore = instance.getExtensionList(
    'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
    )[0].getStore()
def existingCreds = CredentialsProvider.lookupCredentials(
    StandardCertificateCredentials.class, instance).findResult {
        it.getName == '${secret_name}' ? it : null
    }
//def newCreds = new UsernamePasswordCredentialsImpl(
//    CredentialsScope.GLOBAL, null,
//    '${description}', '${username}', '${password}')
def privateKeySource = new BasicSSHUserPrivateKey.DirectEntryPrivateKeySource('${private_key}')
def newCreds = new BasicSSHUserPrivateKey(
    CredentialsScope.GLOBAL, '${secret_name}',
    '${username}', privateKeySource, '${password}', '${description}',)
if (existingCreds) {
    credstore.updateCredentials(domain, existingCreds, newCreds)
} else {
    credstore.addCredentials(domain, newCreds)
}