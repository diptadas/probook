# MAC OS

## Configure ZSH

- Install Antigen

```
$ curl -L git.io/antigen > ~/antigen.zsh
```

- Edit `.zshrc`

```
# Use antigen
source $HOME/antigen.zsh

# Use Oh-My-Zsh
antigen use oh-my-zsh

# Set theme
# antigen theme robbyrussell
# antigen theme romkatv/powerlevel10k

# https://github.com/zsh-users/antigen/issues/675#issuecomment-452764451
THEME=romkatv/powerlevel10k
antigen list | grep $THEME; if [ $? -ne 0 ]; then antigen theme $THEME; fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set plugins (plugins not part of Oh-My-Zsh can be installed using githubusername/repo)
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/295#issuecomment-214581607
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle osx
fi

# Apply changes
antigen apply
```

# Replace Text Edit as the default text editor

```
$ brew install duti
$ duti -s com.microsoft.VSCode public.plain-text all
```

- https://apple.stackexchange.com/a/123954
- https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/understanding_utis/understand_utis_conc/understand_utis_conc.html

## bits/stdc++ with g++

- Create an empty `bits/stdc++.h` file in `/usr/local/include`
- Copy content from [here](https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/include/precompiled/stdc%2B%2B.h)
