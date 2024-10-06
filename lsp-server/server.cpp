#include <iostream>
#include <filesystem>
#include <fstream>

namespace fs = std::filesystem;

int main(int argc, char** argv) {
    if (argc < 1 || argv[0] == NULL) {
        std::cerr << "Invalid usage, missing executable path in argv.";
        return -1;
    }

    fs::path exec_path = fs::absolute(fs::path(argv[0]));
    fs::path exec_dir  = exec_path.parent_path();
    fs::path log_path  = exec_dir / "log.txt";

    std::ofstream stream(log_path);

    while (std::cin.good()) {
        // Первая строка: "Content-Length: <length>\n"
        // Whitespace character is not extracted.
        //   https://en.cppreference.com/w/cpp/io/basic_istream/operator_gtgt2

        std::cin.ignore(std::string_view("Content-Length").size(), ' ');

        size_t msg_length = 0;
        std::cin >> msg_length;

        // \n\n{
        //   Один \n остался с предыдущего чтения длины, whitespace символ
        //   не изымается из потока при форматированном чтении.
        std::cin.ignore(2, '{');

        if (!std::cin.good()) {
            // Поймали какую-то ошибку или конец файла. Выйдем.
            //   Не будем оперировать неверным msg_length.
            break;
        }

        auto buffer = std::make_unique<char[]>(msg_length);
        std::cin.read(buffer.get(), msg_length);

        if (!std::cin.good()) {
            // Поймали какую-то ошибку или конец файла. Выйдем.
            //   Не будем оперировать неверным сообщением.
            break;
        }

        std::string msg(std::string_view(buffer.get(), msg_length));
        stream << msg << '\n';
    }


    return 0;
}