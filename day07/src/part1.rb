#!/usr/bin/env ruby



HAND_TYPE_ORDER_MAP = {
    :five_of_a_kind => 0,
    :four_of_a_kind => 1,
    :full_house => 2,
    :three_of_a_kind => 3,
    :two_pair => 4,
    :one_pair => 5,
    :high_card => 6
}
def get_hand_type(card_hash)
    if card_hash.has_value?(5)
        return :five_of_a_kind
    elsif card_hash.has_value?(4)
        return :four_of_a_kind
    elsif card_hash.has_value?(3)
        return card_hash.has_value?(2) ? :full_house : :three_of_a_kind
    elsif card_hash.has_value?(2)
        pair_count = card_hash.values.select{|count| count == 2}.size
        return pair_count == 2 ? :two_pair : :one_pair
    else
        return :high_card
    end
end

CARD_ORDER_MAP = {
    "A" => 0,
    "K" => 1,
    "Q" => 2,
    "J" => 3,
    "T" => 4,
    "9" => 5,
    "8" => 6,
    "7" => 7,
    "6" => 8,
    "5" => 9,
    "4" => 10,
    "3" => 11,
    "2" => 12
}



class HandAndBid
    def initialize(cards, bid)
        @cards = cards
        @bid = bid
        @hand = Hand.new(cards)
    end

    def hand
        @hand
    end
    def bid
        @bid
    end

    def <=>(other)
        return @hand <=> other.hand
    end
end
class Hand
    def initialize(cards)
        @cards = cards

        @card_hash = {}
        cards.each_char {|c|
            if @card_hash.has_key?(c)
                @card_hash[c] = @card_hash[c] + 1
            else
                @card_hash[c] = 1
            end
        }

        @type = get_hand_type(@card_hash)
    end

    def cards
        @cards
    end
    def type
        @type
    end

    def <=>(other)
        if @type != other.type
            return HAND_TYPE_ORDER_MAP[@type] <=> HAND_TYPE_ORDER_MAP[other.type]
        end

        for i in 0..@cards.size do
            if @cards[i] != other.cards[i]
                return CARD_ORDER_MAP[@cards[i]] <=> CARD_ORDER_MAP[other.cards[i]]
            end
        end
    end
end

filename = ARGV.last
bids = File.readlines(filename, chomp: true)
    .map { |line|
        cards, bid = line.split(" ")
        HandAndBid.new(cards, Integer(bid))
    }

answer = bids.sort.reverse.each_with_index.map {|bid, index|
    bid.bid * (index + 1)
}.reduce(0, :+)

print("Answer: #{answer}\n")
