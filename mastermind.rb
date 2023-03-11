require 'pry-byebug'

PROMPT_GAME_EXPLANATION = "This is a game of Mastermind!

You are going to choose between being the code BREAKER or the code MAKER.
The code MAKER be prompted to make the code, and the code BREAKER will be 
prompted to make a guess. You can choose to local play multiplayer, with 
a friend, or if you are the BREAKER, against the computer.

The code consists of 4 numbers, and the numbers have to be between 1 and 6.

If a guess contains a correct number at the correct location, you will be
shown a ' ■ ', without telling you WHICH number. If a guess contains the 
correct number, but at the wrong location, you will be shown a ' o ', wit-
-hout telling you WHICH number\n\n\n"

class Game
    def initialize
        puts PROMPT_GAME_EXPLANATION
        @board = Board.new
    end

    def play
        replay = true

        while replay
            replay = false
            win = false

            local_multiplayer = prompt_local_multiplayer?
            player_breaker = prompt_player_breaker?

            breaker = Player.new(@board, true)
            master = Player.new(@board, false)

            if local_multiplayer
                master.make_code(prompt_code)
            else
                master.make_code(master.random_code)
            end

            @board.display_board(false)

            while !win
                if local_multiplayer
                    guess = prompt_breaker_guess
                    win = breaker.make_guess(guess)
                    @board.display_board(win)

                elsif !player_breaker
                    win = breaker.make_guess(breaker.random_code)
                    @board.display_board(win)
                    sleep 0.5
                end

                if win == nil || win
                    if prompt_replay
                        replay = true
                        @board = Board.new
                    end
                    break
                end
            end
        end
    end

    def prompt_local_multiplayer?
        puts "Do you want to play against another player locally? (y/...)"
        answer = gets.chomp.downcase

        return (answer == "y" ? true : false)
    end

    def prompt_player_breaker?
        puts "Do you want to be the code BREAKER? (y/...)"
        answer = gets.chomp.downcase

        return (answer == "y" ? true : false)
    end
    
    def prompt_code
        puts "What do you want the code to be? (it must be 4 numbers, all between 1 and 6)"
        code = gets.chomp.split('')
        
        code_within_rules(code)
    end        
    
    def prompt_breaker_guess
        puts "Write your guess with 4 numbers, each between 1 and 6"
        guess = gets.chomp.split('')
        code_within_rules = false
        
        code_within_rules(guess)
    end

    def code_within_rules(code)
        code_within_rules = false

        while !code_within_rules
            if code.length != 4
                puts "Your ocde must be 4 numbers, all between 1 and 6."
                code = gets.chomp.split('')
                next
            end

            code.each do |num|
                num = num.to_i
                if num > 6 || num < 1
                    puts "Your ocde must be 4 numbers, all between 1 and 6."
                    code_within_rules = false
                    break 
                else
                    code_within_rules = true
                end
            end
            
            unless code_within_rules
                code = gets.chomp.split('')
            end
        end

        code.map(&:to_i)
    end

    def prompt_replay
        puts "Do you want to play again? (y/...)"
        answer = gets.chomp.downcase

        return (answer == 'y' ? true : false)
    end
end

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

    def random_code
       code = Array.new(4) {rand(1..6)}
    end
    
    def make_guess(code_guess)
        if guess_counter < 0
            puts "You lost! No more guesses left!"
            return
        end

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

        return false
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
        if win || win == nil
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

game = Game.new
game.play