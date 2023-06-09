pipeline {
    agent any

    environment {
        // Set local path
        LOCAL_PATH = "${env.WORKSPACE}\\Software"
        // Set network path
        NETWORK_PATH = "\\server\\share"
        // Set folder name with spaces
        FOLDER_NAME = "Software with Spaces"
    }

    stages {
        stage('Copy Software Installers') {
            steps {
                script {
                    // Check if the local directory exists
                    def localDirExists = bat(returnStatus: true, script: "if exist \"${LOCAL_PATH}\\${FOLDER_NAME}\" (exit 0) else (exit 1)")
                    if (localDirExists == 0) {
                        echo "Local folder already exists. Removing existing folder."
                        bat "rmdir /s /q \"${LOCAL_PATH}\\${FOLDER_NAME}\""
                    }

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
                    if (!isInstalled('Git')) {
                        installSoftware('Git', "${LOCAL_PATH}\\${FOLDER_NAME}\\GitInstaller.exe", '"/SILENT"')
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
                        installSoftware('Maven', "${LOCAL_PATH}\\${FOLDER_NAME}\\maven.zip", '')
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
                        installSoftware('Node.js', "${LOCAL_PATH}\\${FOLDER_NAME}\\NodeInstaller.msi", '"/i /qn"')
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
                        installSoftware('Micro Focus UFT', "${LOCAL_PATH}\\${FOLDER_NAME}\\UFT.iso", '"/qn"')
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
                        installSoftware('JDK', "${LOCAL_PATH}\\${FOLDER_NAME}\\JDKInstaller.exe", '"/s"')
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
