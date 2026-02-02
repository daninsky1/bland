function hide_prompt
    functions --copy fish_prompt fish_prompt_original
    function fish_prompt; echo '> '; end
    clear
end

function restore_prompt
    functions --erase fish_prompt
    functions --copy fish_prompt_original fish_prompt
    functions --erase fish_prompt_original
    clear
end
