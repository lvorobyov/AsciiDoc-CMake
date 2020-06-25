function(add_doc _source)
    get_filename_component(BASENAME ${_source} NAME_WE)
    set(TEX_FILE ${CMAKE_CURRENT_LIST_DIR}/${BASENAME}.tex)
    set(_main "")
    if (${ARGC} GREATER 1 AND (${ARGV1} OR ${ARGV1} MATCHES "\\.bib$"))
        # Check is bibtex file presented
        set(_main "BEGIN{$pre = 1;} \
				   if ($pre) {\
					 if ($pre == 1 and s/^=\\s+(.+)$/\\\\title{\\1}/) { \
					   $pre = 2; \
					 } elsif ($pre == 2 and s/^(.+)$/\\\\author{\\1}/) { \
					   $pre = 3; \
					 } elsif (s/^:(\\w+): (.+)/\\\\\\1{\\2}/) { \
					 } else { \
				       print qq(\\\\begin{document}\\n); \
					   print qq(\\\\maketitle\\n) if ($pre > 1); \
					   $pre = 0; \
					 } \
				   } \
                   END{print qq(\\n\\\\end{document}\\n);}")
    endif()
    add_custom_command(OUTPUT ${TEX_FILE}
            COMMAND perl -MAsciiDoc -C -lpe "chomp; ${_main} to_latex($_, qq(\\n));" < ${_source} > ${TEX_FILE}
            WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
            DEPENDS ${_source} VERBATIM)
endfunction()
