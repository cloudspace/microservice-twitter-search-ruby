#################################################################
#
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#
#################################################################

FROM cloudspace/microbase-ruby:0.1
MAINTAINER Josh Lauer <jlauer@cloudspace.com>

ADD run.rb /run.rb
ADD twitter_search.rb /twitter_search.rb
RUN chmod 755 /run.rb