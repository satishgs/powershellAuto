pipeline {
    agent any

    environment {
        // Set local path
        LOCAL_PATH = "${env.WORKSPACE}\\Software"
        // Set network path
        NETWORK_PATH = "\\server\\share"
    }

    stages {
        stage('Copy Software Installers') {
            steps {
                script {
                    // Create the local directory
                    bat "mkdir ${LOCAL_PATH}"

                    // Copy software installers to the local directory, overwriting existing files
                    bat "xcopy /Y /Q ${NETWORK_PATH}\\GitInstaller.exe ${LOCAL_PATH}"
                    bat "xcopy /Y /Q ${NETWORK_PATH}\\maven.zip ${LOCAL_PATH}"
                    bat "xcopy /Y /Q ${NETWORK_PATH}\\NodeInstaller.msi ${LOCAL_PATH}"
                    bat "xcopy /Y /Q ${NETWORK_PATH}\\UFT.iso ${LOCAL_PATH}"
                    bat "xcopy /Y /Q ${NETWORK_PATH}\\JDKInstaller.exe ${LOCAL_PATH}"

                    // Display the local path
                    echo "Local Path: ${LOCAL_PATH}"
                }
            }
        }

        stage('Install Git') {
            steps {
                script {
                    if (!isInstalled('Git')) {
                        installSoftware('Git', "${LOCAL_PATH}\\GitInstaller.exe", '"/SILENT"')
                    } else {
                        echo "Git is already installed"
                    }
                }
            }
        }

        stage('Install Maven') {
            steps {
                script {
                    if (!isInstalled('Maven')) {
                        installSoftware('Maven', "${LOCAL_PATH}\\maven.zip", '')
                    } else {
                        echo "Maven is already installed"
                    }
                }
            }
        }

        stage('Install Node.js') {
            steps {
                script {
                    if (!isInstalled('Node.js')) {
                        installSoftware('Node.js', "${LOCAL_PATH}\\NodeInstaller.msi", '"/i /qn"')
                    } else {
                        echo "Node.js is already installed"
                    }
                }
            }
        }

        stage('Install Micro Focus UFT') {
            steps {
                script {
                    if (!isInstalled('Micro Focus UFT')) {
                        installSoftware('Micro Focus UFT', "${LOCAL_PATH}\\UFT.iso", '"/qn"')
                    } else {
                        echo "Micro Focus UFT is already installed"
                    }
                }
            }
        }

        stage('Install JDK') {
            steps {
                script {
                    if (!isInstalled('JDK')) {
                        installSoftware('JDK', "${LOCAL_PATH}\\JDKInstaller.exe", '"/s"')
                    } else {
                        echo "JDK is already installed"
                    }
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

        // Display a visual indicator while waiting
        for (int i = 10; i > 0; i--) {
            echo "Waiting for ${name} installation to complete... ${i}"
            sleep 1
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
