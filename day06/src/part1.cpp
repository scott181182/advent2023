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



void read_input(const char* filename, vector<Race>& races) {
    races.clear();
    string time_line;
    string dist_line;

    ifstream file(filename);
    getline(file, time_line);
    getline(file, dist_line);

    regex number_regex("(\\d+)", regex::ECMAScript);
    auto time_match_iter = sregex_iterator(time_line.begin(), time_line.end(), number_regex);
    auto dist_match_iter = sregex_iterator(dist_line.begin(), dist_line.end(), number_regex);
    auto match_end = sregex_iterator();

    sregex_iterator i = time_match_iter;
    sregex_iterator j = dist_match_iter;
    while(i != match_end && j != match_end) {
        string time_str = i->str();
        string dist_str = j->str();
        // printf("    %s -> %s\n", time_str.c_str(), dist_str.c_str());
        Race race(stoul(time_str), stoul(dist_str));
        races.push_back(race);

        i++; j++;
    }
}



int main(int argc, char* argv[]) {
    if(argc != 2) {
        throw invalid_argument("Expected single filename argument, but found " + to_string(argc - 1));
    }

    vector<Race> races;
    read_input(argv[1], races);
    
    // for(auto race = races.begin(); race != races.end(); race++) {
    //     printf("Race: %lu, %lu\n", race->time, race->distance);
    //     uint64_t min_time = race->min_time();
    //     uint64_t max_time = race->max_time();
    //     printf("    times: %lu, %lu\n", min_time, max_time);
    //     printf("    spread: %lu\n", max_time - min_time + 1);
    // }

    vector<uint64_t> times;
    times.resize(races.size());
    transform(races.begin(), races.end(), times.begin(), 
        [](const Race& race) { return race.winning_times(); });

    uint64_t total = accumulate(times.begin(), times.end(), 1, multiplies<uint64_t>());
    printf("Answer: %lu\n", total);

    return 0;
}