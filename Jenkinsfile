pipeline {
    agent any

    environment {
        // Set local path
        LOCAL_PATH = "${env.WORKSPACE}\\Software"
        // Set network path
        NETWORK_PATH = "\\server\\share"
        // Set folder name with spaces
        FOLDER_NAME = "Software with Spaces"
        // Set Maven home
        MAVEN_HOME = "${LOCAL_PATH}\\${FOLDER_NAME}\\maven"
        // Set Java home
        JAVA_HOME = "${LOCAL_PATH}\\${FOLDER_NAME}\\jdk"
    }

    stages {
        stage('Copy Software Installers') {
            steps {
                script {
                    // Remove the existing local folder if it exists
                    bat "if exist \"${LOCAL_PATH}\\${FOLDER_NAME}\" rmdir /s /q \"${LOCAL_PATH}\\${FOLDER_NAME}\""

                    // Create the local directory
                    bat "mkdir \"${LOCAL_PATH}\\${FOLDER_NAME}\""

                    // Copy software installers to the local directory, overwriting existing files
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\GitInstaller.exe\" \"${LOCAL_PATH}\\${FOLDER_NAME}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\maven.zip\" \"${LOCAL_PATH}\\${FOLDER_NAME}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\NodeInstaller.msi\" \"${LOCAL_PATH}\\${FOLDER_NAME}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\UFT.iso\" \"${LOCAL_PATH}\\${FOLDER_NAME}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\JDKInstaller.exe\" \"${LOCAL_PATH}\\${FOLDER_NAME}\""

                    // Display the local path
                    echo "Local Path: ${LOCAL_PATH}\\${FOLDER_NAME}"
                }
            }
        }

        stage('Install Git') {
            steps {
                script {
                    installSoftware('Git', "${LOCAL_PATH}\\${FOLDER_NAME}\\GitInstaller.exe", '"/SILENT"')
                }
            }
        }

        stage('Install Maven') {
            steps {
                script {
                    installSoftware('Maven', "${LOCAL_PATH}\\${FOLDER_NAME}\\maven.zip", '')

                    // Set MAVEN_HOME environment variable
                    bat "echo MAVEN_HOME=${MAVEN_HOME} > ${MAVEN_HOME}\\env.properties"
                }
            }
        }

        stage('Install Node.js') {
            steps {
                script {
                    installSoftware('Node.js', "${LOCAL_PATH}\\${FOLDER_NAME}\\NodeInstaller.msi", '"/i /qn"')
                }
            }
        }

        stage('Unpack UFT Installer') {
            steps {
                script {
                    // Unzip the UFT installer
                    bat "powershell.exe -Command \"Expand-Archive -Path \\\"${LOCAL_PATH}\\${FOLDER_NAME}\\UFT.iso\\\" -DestinationPath \\\"${LOCAL_PATH}\\${FOLDER_NAME}\\UFT\\\"\""
                }
            }
        }

        stage('Install Micro Focus UFT') {
            steps {
                script {
                    installSoftware('Micro Focus UFT', "${LOCAL_PATH}\\${FOLDER_NAME}\\UFT\\UFTInstaller.exe", '"/qn"')
                }
            }
        }

        stage('Install JDK') {
            steps {
                script {
                    installSoftware('JDK', "${LOCAL_PATH}\\${FOLDER_NAME}\\JDKInstaller.exe", '"/s"')

                    // Set JAVA_HOME environment variable
                    bat "echo JAVA_HOME=${JAVA_HOME} > ${JAVA_HOME}\\env.properties"
                }
            }
        }
    }

    post {
        success {
            echo 'All installations completed successfully'
        }
        failure {
            echo 'One or more installations failed'
        }
    }
}

def installSoftware(name, installerPath, arguments) {
    def progressColor = 'GREEN'

    echo "Installing ${name}..."

    progressBar(progressBarOptions: [currentBuildProgress: "${currentBuild.currentStageIndex}/${currentBuild.totalStages}", progressColor: progressColor], description: "Installing ${name}") {
        bat "start /WAIT ${installerPath} ${arguments}"

        // Wait for the installation to complete
        waitUntil {
            isInstalled(name)
        }

        // Validate installation
        if (isInstalled(name)) {
            echo "${name} installation successful."
        } else {
            error "${name} installation failed."
        }
    }
}

def isInstalled(name) {
    def installed = false

    switch (name) {
        case 'Git':
            installed = bat(returnStatus: true, script: 'git --version') == 0
            break
        case 'Maven':
            installed = bat(returnStatus: true, script: 'mvn --version') == 0
            break
        case 'Node.js':
            installed = bat(returnStatus: true, script: 'node --version') == 0
            break
        case 'Micro Focus UFT':
            installed = bat(returnStatus: true, script: 'uft --version') == 0
            break
        case 'JDK':
            installed = bat(returnStatus: true, script: 'java -version') == 0
            break
        default:
            echo "Unknown software name: ${name}"
    }

    return installed
}
