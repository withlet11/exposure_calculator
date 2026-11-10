allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

layout.buildDirectory = file("../build")
subprojects {
    layout.buildDirectory = file("${rootProject.layout.buildDirectory.get().asFile.path}/${project.name}")
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    description = "Deletes all build artifacts"
    delete(rootProject.layout.buildDirectory)
}