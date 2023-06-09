pipeline {
    agent any

    environment {
        // Set local drive
        LOCAL_DRIVE = "D:"
        // Set folder name with spaces
        FOLDER_NAME = "Software with Spaces"
        // Set local path
        LOCAL_PATH = "${LOCAL_DRIVE}\\${FOLDER_NAME}"
        // Set network path
        NETWORK_PATH = "\\server\\share"
        // Set Maven home
        MAVEN_HOME = "${LOCAL_PATH}\\maven"
        // Set Java home
        JDK_HOME = "${LOCAL_PATH}\\jdk"
        // Set JDK bin directory
        JDK_BIN_DIR = "${JDK_HOME}\\bin"
    }

    stages {
        stage('Copy Software Installers') {
            steps {
                script {
                    // Remove the existing local folder if it exists
                    bat "if exist \"${LOCAL_PATH}\" rmdir /s /q \"${LOCAL_PATH}\""

                    // Create the local directory
                    bat "mkdir \"${LOCAL_PATH}\""

                    // Copy software installers to the local directory, overwriting existing files
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\GitInstaller.exe\" \"${LOCAL_PATH}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\maven.zip\" \"${LOCAL_PATH}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\NodeInstaller.msi\" \"${LOCAL_PATH}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\UFT.iso\" \"${LOCAL_PATH}\""
                    bat "xcopy /Y /Q \"${NETWORK_PATH}\\JDKInstaller.exe\" \"${LOCAL_PATH}\""

                    // Display the local path
                    echo "Local Path: ${LOCAL_PATH}"
                }
            }
        }

        stage('Install Git') {
            steps {
                script {
                    installSoftware('Git', "${LOCAL_PATH}\\GitInstaller.exe", '"/SILENT"')
                }
            }
        }

        stage('Install Maven') {
            steps {
                script {
                    installMaven("${LOCAL_PATH}\\maven.zip")
                }
            }
        }

        stage('Install Node.js') {
            steps {
                script {
                    installSoftware('Node.js', "${LOCAL_PATH}\\NodeInstaller.msi", '"/i /qn"')
                }
            }
        }

        stage('Unpack UFT Installer') {
            steps {
                script {
                    // Unzip the UFT installer
                    bat "powershell.exe -Command \"Expand-Archive -Path '${LOCAL_PATH}\\UFT.iso' -DestinationPath '${LOCAL_PATH}\\UFT'\""
                }
            }
        }

        stage('Install Micro Focus UFT') {
            steps {
                script {
                    installSoftware('Micro Focus UFT', "${LOCAL_PATH}\\UFT\\UFTInstaller.exe", '"/qn"')
                }
            }
        }

        stage('Install JDK') {
            steps {
                script {
                    installSoftware('JDK', "${LOCAL_PATH}\\JDKInstaller.exe", '"/s"')
                }
            }
        }
    }

    post {
        success {
            script {
                setJavaHome()
                setMavenHome()
            }
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

def installMaven(mavenZipPath) {
    def mavenExtractPath = "${MAVEN_HOME}\\apache-maven"
    def mavenBinPath = "${mavenExtractPath}\\bin"

    echo "Installing Maven..."
    progressBar(progressBarOptions: [currentBuildProgress: "${currentBuild.currentStageIndex}/${currentBuild.totalStages}", progressColor: 'GREEN'], description: "Installing Maven") {
        bat "powershell.exe -Command \"Expand-Archive -Path '${mavenZipPath}' -DestinationPath '${MAVEN_HOME}'\""
    }
    env.PATH = "${env.PATH};${mavenBinPath}"
    env.MAVEN_HOME = mavenExtractPath
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

def setJavaHome() {
    // Set JAVA_HOME environment variable on Windows
    if (isWindows()) {
        def javaHomeDir = findJavaHomeDir(JDK_HOME)
        if (javaHomeDir != null) {
            env.JAVA_HOME = javaHomeDir
            bat 'setx JAVA_HOME "%JAVA_HOME%"'
            bat 'setx PATH "%PATH%;%JAVA_HOME%\\bin"'
        } else {
            error "Unable to locate JDK installation directory"
        }
    }
}

def findJavaHomeDir(jdkHomeDir) {
    def javaHomeDir = null

    def file = new File(jdkHomeDir)
    def jdkDirs = file.listFiles()?.toList() ?: []

    jdkDirs.each { dir ->
        if (dir.name.toLowerCase().startsWith("jdk")) {
            javaHomeDir = dir.absolutePath
            return false // Stop iterating once JDK directory is found
        }
    }

    return javaHomeDir
}

def setMavenHome() {
    // Set MAVEN_HOME environment variable on Windows
    if (isWindows()) {
        bat 'setx MAVEN_HOME "${env.MAVEN_HOME}"'
        bat 'setx PATH "%PATH%;%MAVEN_HOME%\\bin"'
    }
}

def isWindows() {
    return isUnix() ? false : true
}

def isUnix() {
    return isUnixLike()
}

def isUnixLike() {
    return !isWindows()
}
