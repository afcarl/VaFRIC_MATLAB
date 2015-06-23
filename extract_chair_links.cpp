#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(void)
{
    std::ifstream ifile("test.txt");

    char readlinedata[500];

    while(1)
    {
        if (ifile.eof())
            break;

        ifile.getline(readlinedata,500);

        std::string lineString(readlinedata);

        if ( lineString.find("id=") != std::string::npos )
        {
            std::size_t found = lineString.find("id");

            std::string substring = lineString.substr(found+3,8);
            if ( substring.find_first_of("0123456789") != std::string::npos )
                  std::cout<<std::string("archive3d.net/?a=download&id=")+substring<<std::endl;
        }
    }

    ifile.close();
}
