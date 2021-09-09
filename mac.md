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
antigen theme robbyrussell
# https://github.com/zsh-users/antigen/issues/675
# use "exec zsh" instead of "source .zshrc"

# Set plugins (plugins not part of Oh-My-Zsh can be installed using githubusername/repo)
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

# https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/295#issuecomment-214581607
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

if [[ "$OSTYPE" == "darwin"* ]]; then
    antigen bundle osx
fi

# Apply changes
antigen apply
```

## bits/stdc++ with g++

- Create an empty `bits/stdc++.h` file in `/usr/local/include`
- Copy content from [here](https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/include/precompiled/stdc%2B%2B.h)
