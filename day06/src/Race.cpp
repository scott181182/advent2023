#include <cmath>
#include <cstdint>
#include <vector>
#include <string>
#include <fstream>
#include <regex>



class Race {
    public:
        uint64_t time;
        uint64_t distance;

        Race(uint64_t time, uint64_t distance) {
            this->time = time;
            this->distance = distance;
        }

        uint64_t min_time() const {
            double actual_time = ((double)this->time - sqrt(this->time * this->time - 4 * this->distance)) / 2.0;
            return floor(actual_time + 1);
        }
        uint64_t max_time() const {
            double actual_time = ((double)this->time + sqrt(this->time * this->time - 4 * this->distance)) / 2.0;
            return ceil(actual_time - 1);
        }
        
        uint64_t winning_times() const {
            return this->max_time() - this->min_time() + 1;
        }
};
