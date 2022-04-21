library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity registers_min_max is 
    port(
        
            din     : in std_logic_vector(3 downto 0); 
            reset   : in std_logic;
            clk     : in std_logic;
            sel     : in std_logic_vector(1 downto 0);  
            max_out : out std_logic_vector(3 downto 0); 
            min_out : out std_logic_vector(3 downto 0);
            reg_out : out std_logic_vector(3 downto 0)

        );
end registers_min_max;

architecture rtl of registers_min_max is

            type s_reg is array(0 to 3) of std_logic_vector(3 downto 0); 
            signal reg               : s_reg;       
            signal max_reg           : std_logic_vector(3 downto 0) := "1000";
            signal min_reg           : std_logic_vector(3 downto 0) := "1000";
            signal current_max       : std_logic_vector(3 downto 0) := "1000";
            signal current_min       : std_logic_vector(3 downto 0) := "1000";  
            signal load_max          : boolean := false;
            signal load_min          : boolean := false;
            
       
                    BEGIN
        
shift_register: process(reset, clk)

                    BEGIN

                        if (reset = '1') then
                            for idx in 0 to reg'length - 1 loop 
                                reg(idx) <= "1000"; 
                            end loop;
                        elsif (reset = '0') then     
                            if(clk'event and clk = '1') then
                                reg(0) <= din; 
                            for idx in 1 to reg'length - 1 loop
                                reg(idx) <= reg(idx - 1);
                             end loop;
                        end if;
                        end if;

                     

                    END process shift_register;

                    
                    
min_max_block:  process(reg)                  
                                                            

                BEGIN
                        
                --***--
                --MAX--
                --***--
             

                --//////////////////////////////////////////////////--
                --largest of four shift registers stored inside temp--
                --//////////////////////////////////////////////////--
                
                if (reg(0) > current_max) then  
                    current_max <= reg(0);
                elsif (reg(1) > current_max) then
                        current_max <= reg(1);
                    elsif (reg(2) > current_max) then
                            current_max <= reg(2);
                        elsif (reg(3) > current_max) then
                                current_max <= reg(3);                            
                end if;   
                                              
                        
                --***--
                --MIN--
                --***--
                      
                --//////////////////////////////////////////////////--
                --smallest of four shift registers stored inside temp--
                --//////////////////////////////////////////////////--
                        
                        
                if (reg(0) < current_min) then
                        current_min <= reg(0);
                    elsif (reg(1) < current_min) then
                            current_min <= reg(1);
                        elsif (reg(2) < current_min) then
                                current_min <= reg(2);
                            elsif (reg(3) < current_min) then
                                    current_min <= reg(3);
                end if;
                        

                --//////////////////////////////////////////--
                --shift_register_output LEDs with switch sel--
                --//////////////////////////////////////////--
                
                                                            
                case sel is
                    when "00" =>
                         reg_out <= reg(0);
                    when "01" =>
                         reg_out <= reg(1);
                    when "10" =>
                         reg_out <= reg(2);
                    when "11" =>
                         reg_out <= reg(3);
                    when others =>
                         reg_out <= "0000";
                end case;
      
                        
                END process min_max_block;


load_flag:      process(current_max, current_min)
                    
                   BEGIN
   
                   --//////////////////////////////////////////////--
                   --compare current_max with max_reg, load if true--
                   --//////////////////////////////////////////////--

                      if (current_max > max_reg) then
                           load_max  <= true;
                           max_reg   <= current_max;
                      else
                           load_max  <= false;
                      end if;
                    

                   --//////////////////////////////////////////////--
                   --compare current_min with min_reg, load if true--
                   --//////////////////////////////////////////////--


                      if(current_min < min_reg) then
                          load_min  <= true;
                          min_reg  <= current_min;
                      else
                          load_min <= false;
                      end if;
                    
                 END process load_flag;
  

output_registers:     process(load_max, load_min)
                        
                      BEGIN
                        
                       if(load_max = true)then
                           max_out <= current_max;
                       else
                           max_out <= max_reg;
                       end if;


                       if(load_min = true) then
                            min_out <= current_min;
                       else
                            min_out <= min_reg;
                       end if;
 
                      END process output_registers;

END rtl;   
    
             
        
