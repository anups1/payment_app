class Instalment
	def initialize(amount,instalment_num)
		@amount = amount
		@instalments = []
		instalment = amount / instalment_num
		(instalment_num-1).times do @instalments << instalment ; amount -= instalment end
		@instalments << amount
	end

	def current_inst()
		return (@instalments.length-1)
	end
	def show()
		puts "#{@instalments} and the remaining amount is #{@amount}"
	end
	
	def pay_(amount, instalment_num) #instalment_num is zero indexed
		last_instalment = (instalment_num == (@instalments.length-1))
		temp = amount - (@instalments[instalment_num])
		if @amount >= amount then		
			if @instalments[instalment_num] < amount
				# amount paid greater than instalment deduct from next; check if last		
				if last_instalment then
					puts "You are giving #{temp} extra. Only #{@instalments[-1]} will be accepted."
				else
					if temp < @instalments[instalment_num+1] then
						@instalments[instalment_num+1] -= temp
					elsif temp >= @instalments[instalment_num+1] then
						while temp > 0 do
							if @instalments[instalment_num+1] <= temp
								temp -= @instalments[instalment_num+1]
								@instalments.delete_at (instalment_num+1) 
							else
								@instalments[instalment_num+1] -= temp
							end
						end
					end 
				end
			elsif @instalments[instalment_num] > amount
				# amount is less offer two options a] add to next instalment; not available if last or b] insert a new instalment <<
				puts "You are paying less than expected amount! What would you like to do?"
				print "Add to my next installment"
				if last_instalment then
					 puts " -- This option is not available as this is supposed to be your last installment" 
				else
					puts "" 
				end
				puts "Create a new installment"
				while true do			
					puts 'Enter "add" or "create" (without quotes) : '
					ans = gets.chomp
					if (ans.casecmp "add") == 0 then
						if last_instalment then
							@instalments << temp*-1
						else
							@instalments[instalment_num+1] -= temp # temp is negative here
						end
						break
					elsif (ans.casecmp "create") == 0 then
						@instalments << temp*-1
						break
					else
						puts "What was that? Please try again."
					end
				end
			end
			#if equal move over to next
			
			@instalments[instalment_num] = amount 
			@amount -= amount
		else
			puts "Amount exceeds total remaining payment please re-enter smaller amount"
		end
	end
end

def validate(amount, instalment_num) # setting maximum number of installments 24
	if amount < 0 or instalment_num < 0 or amount < instalment_num or instalment_num > 24 then
		return false
	else
		return true
	end
end


puts "Enter the amount of student's fees and number of installments separated by a space: [fees] [number of installments] "
f, n_instal = gets.scan(/-?\d+/).map(&:to_i)
if validate(f,n_instal) then
	student = Instalment.new(f, n_instal)
	student.show()
	puts "Enter the installments one by one on each line : "
	i = 0
	while true do
		amount = gets.to_i
		student.pay_(amount,i)
		student.show()
		break if i >= student.current_inst() 
		i += 1		
	end
else
	puts "Fees or number of installments not validated. Please try again."
end
# student.show()

# student = Instalment.new(10000,3)
# student.show()
