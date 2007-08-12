# redMine - project management software
# Copyright (C) 2006-2007  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class MessageObserver < ActiveRecord::Observer
  def after_create(message)
    # send notification to the authors of the thread
    recipients = ([message.root] + message.root.children).collect {|m| m.author.mail if m.author}
    # send notification to the board watchers
    recipients += message.board.watcher_recipients
    recipients = recipients.compact.uniq
    Mailer.deliver_message_posted(message, recipients) unless recipients.empty?
  end
end
