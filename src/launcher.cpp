

#include "../include/launcher.hpp"

QVariantList Launcher::list_apps() {
    QVariantList apps;

    const char*  env = getenv("XDG_DATA_DIRS");

    if (!env)
        return apps;

    char* dirs    = strdup(env);
    char* cur_dir = strtok(dirs, ":");

    while (cur_dir) {
        std::string path = std::string(cur_dir) + "/applications";

        if (std::filesystem::exists(path)) {
            for (auto app : std::filesystem::directory_iterator(path)) {

                if (app.path().extension() != ".desktop")
                    continue;

                std::fstream file;
                file.open(app.path(), std::ios::in);

                if (!file)
                    continue;

                App_t       app_md;
                std::string line;
                bool        is_app           = false;
                bool        is_hidden        = false;
                bool        is_desktop_entry = false;

                while (std::getline(file, line)) {
                    if (line == "[Desktop Entry]") {
                        is_desktop_entry = true;
                        continue;
                    }

                    if (is_desktop_entry && line.starts_with("["))
                        break;

                    if (line == "Type=Application")
                        is_app = true;

                    else if (line == "NoDisplay=true" || line == "Hidden=true")
                        is_hidden = true;

                    else if (line.starts_with("Name="))
                        app_md.name = line.substr(5);

                    else if (line.starts_with("Icon="))
                        app_md.icon = line.substr(5);

                    else if (line.starts_with("Exec="))
                        app_md.exec = line.substr(5);
                }
                if (is_app && !is_hidden) {
                    QVariantMap item;

                    item["name"] = QString::fromStdString(app_md.name);
                    item["icon"] = QString::fromStdString(app_md.icon);
                    item["exec"] = QString::fromStdString(app_md.exec);

                    apps.append(item);
                }
            }
        }

        cur_dir = strtok(nullptr, ":");
    }

    free(dirs);

    return apps;
}

void Launcher::launch(QString command) {

    QString             program_name = QProcess::splitCommand(command).takeFirst();

    QProcess            process;

    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();

    env.insert("WAYLAND_DISPLAY", "wayboard-0");
    env.insert("QT_QPA_PLATFORM", "wayland");
    env.insert("GDK_BACKEND", "wayland");

    // electron apps default to x11. still didn't implement xwayland
    env.remove("DISPLAY");
    env.insert("XDG_SESSION_TYPE", "wayland");
    env.insert("ELECTRON_OZONE_PLATFORM_HINT", "wayland");

    process.setProcessEnvironment(env);

    process.setProgram(program_name);

    process.startDetached();
}