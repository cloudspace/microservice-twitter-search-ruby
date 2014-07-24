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
RUN /.rbenv/versions/2.1.2/bin/gem install twitter --no-ri --no-rdoc
RUN /.rbenv/versions/2.1.2/bin/gem install pry-byebug --no-ri --no-rdoc