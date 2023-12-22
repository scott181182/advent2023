#include <stdio.h>

#include <algorithm>
#include <cmath>
#include <exception>
#include <fstream>
#include <numeric>
#include <regex>
#include <string>
#include <vector>

#include "Race.cpp"

using namespace std;



void remove_spaces(string& line) {
    string::iterator new_end = remove(line.begin(), line.end(), ' ');
    line.erase(new_end, line.end());
}

Race read_input(const char* filename) {
    string time_line;
    string dist_line;

    ifstream file(filename);
    getline(file, time_line);
    getline(file, dist_line);

    // Correct kerning.
    remove_spaces(time_line);
    remove_spaces(dist_line);

    regex number_regex("(\\d+)", regex::ECMAScript);
    smatch time_match;
    smatch dist_match;
    regex_search(time_line, time_match, number_regex);
    regex_search(dist_line, dist_match, number_regex);

    string time_str = time_match.str();
    string dist_str = dist_match.str();
    // printf("    %s -> %s\n", time_str.c_str(), dist_str.c_str());
    Race race(stoul(time_str), stoul(dist_str));
    return race;
}



int main(int argc, char* argv[]) {
    if(argc != 2) {
        throw invalid_argument("Expected single filename argument, but found " + to_string(argc - 1));
    }

    Race race = read_input(argv[1]);
    
    // for(auto race = races.begin(); race != races.end(); race++) {
    //     printf("Race: %lu, %lu\n", race->time, race->distance);
    //     uint64_t min_time = race->min_time();
    //     uint64_t max_time = race->max_time();
    //     printf("    times: %lu, %lu\n", min_time, max_time);
    //     printf("    spread: %lu\n", max_time - min_time + 1);
    // }
    printf("Answer: %lu\n", race.winning_times());

    return 0;
}