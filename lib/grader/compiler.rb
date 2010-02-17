module Compiler
  class Cpp
    include ShellUtils
    
    def compile(src_file, output_file, options = {})
      verbose_system "g++ #{src_file} -o #{output_file} -O2 -s -static -lm -x c++"
    end
  end
  
  class Pascal
    def compile(src_file, output_file, options = {})
      verbose_system "g++ #{src_file} -o #{output_file} -O2 -s -static -lm -x c++"
    end
  end
end

Grader.class_eval do
  LANG_TO_COMPILER[Run::LANG_C_CPP] = Cpp
  LANG_TO_COMPILER[Run::LANG_PAS] = Pascal
end