require 'pry-byebug'

class Player
    attr_reader :code_breaker, :board
    attr_accessor :guess_counter
    
    def initialize(board, code_breaker)
        @board = board
        @code_breaker = code_breaker
        @guess_counter = 9
    end
    
    def make_code(code)
        if code_breaker
            return
        end
        
        board.code = code
    end
    
    def make_guess(code_guess)
        unless code_breaker
            return
        end

        board.board[guess_counter] = code_guess
        
        if code_guess == board.code
            puts "You won!"
            4.times {board.guesses[guess_counter] << "■"}
            return true
        else
            code_guess.each_with_index do |guess, i|
                if board.code.include?(guess)
                    if board.code.find_index(guess) == i
                        board.guesses[guess_counter] << "■"
                    else
                        board.guesses[guess_counter] << "o"
                    end
                    
                    board.guesses[guess_counter].sort!
                end
            end
            
            @guess_counter = @guess_counter - 1
        end
        
    end
    
end

class Board
    attr_accessor :code, :board, :guesses
    
    def initialize
        @code = Array.new(4) {0}
        @board = Array.new(10) {Array.new(4) {0}}            
        @guesses = Array.new(10) {Array.new()}
    end
    
    def display_board(win)
        if win
            p code
        else
            p Array.new(4) {"Ø"}
        end

        puts ""
        
        board.each_with_index do |row, i|
            print row
            print "     "
            p guesses[i]
        end
    end
end

board = Board.new
code_master = Player.new(board, false)
code_breaker = Player.new(board, true)

code_master.make_code([1,2,3,4])

win = code_breaker.make_guess([2, 2, 4, 4])

board.display_board(win)