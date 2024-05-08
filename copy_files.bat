#include <iostream>
#include <filesystem>
#include <string>

namespace fs = std::filesystem;

int main(int argc, char* argv[]) {
    // Перевірка аргументів командного рядка
    if (argc < 3) {
        std::cerr << "Недостатньо параметрів командного рядка." << std::endl;
        std::cerr << "Використання: " << argv[0] << " <джерело> <призначення> [<фільтр>]" << std::endl;
        return 1;
    }

    // Зчитування аргументів командного рядка
    std::string source_dir = argv[1];
    std::string dest_dir = argv[2];
    std::string filter = (argc >= 4) ? argv[3] : "";

    // Перевірка наявності вихідного та цільового каталогів
    if (!fs::exists(source_dir)) {
        std::cerr << "Вихідний каталог не існує: " << source_dir << std::endl;
        return 1;
    }

    if (!fs::exists(dest_dir)) {
        std::cerr << "Цільовий каталог не існує: " << dest_dir << std::endl;
        return 1;
    }

    // Сканування файлів у вихідному каталозі
    for (const auto& entry : fs::directory_iterator(source_dir)) {
        if (entry.is_regular_file()) {
            std::string file_path = entry.path().string();
            std::string file_name = entry.path().filename().string();

            // Пропускайте файли, якщо фільтр не порожній і не відповідає шаблону
            if (!filter.empty() && file_name.find(filter) == std::string::npos) {
                continue;
            }

            // Копіювання файлу
            std::string dest_file_path = dest_dir + "/" + file_name;

            try {
                fs::copy(file_path, dest_file_path, fs::copy_options::overwrite_existing | fs::copy_options::copy_symlinks);
                std::cout << "Файл " << file_path << " успішно скопійовано до " << dest_file_path << std::endl;
            } catch (const fs::filesystem_error& e) {
                std::cerr << "Помилка при копіюванні файлу: " << file_name << std::endl;
                std::cerr << e.what() << std::endl;
            }
        }
    }

    std::cout << "Копіювання завершено." << std::endl;
    return 0;
}
