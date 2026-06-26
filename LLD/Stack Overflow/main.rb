require 'date'

# --- Enums / Constants ---
module VoteType
  UPVOTE = 1
  DOWNVOTE = -1
end

# --- Value Objects & Mixins ---
module Votable
  attr_reader :votes

  def initialize_votable
    @votes = []
  end

  def add_vote(vote)
    # Remove existing vote by same user to prevent double voting
    @votes.reject! { |v| v.user.id == vote.user.id }
    @votes << vote
    update_author_reputation(vote)
  end

  def vote_score
    @votes.sum(&:value)
  end

  private

  def update_author_reputation(vote)
    points = vote.value == VoteType::UPVOTE ? 10 : -5
    @author.update_reputation(points)
  end
end

module Commentable
  attr_reader :comments

  def initialize_commentable
    @comments = []
  end

  def add_comment(comment)
    @comments << comment
  end
end

# --- Core Classes ---

class User
  attr_reader :id, :username, :email, :reputation

  def initialize(id, username, email)
    @id = id
    @username = username
    @email = email
    @reputation = 0
    @mutex = Mutex.new # Ensures thread-safe reputation updates
  end

  def update_reputation(points)
    @mutex.synchronize do
      @reputation += points
      @reputation = 0 if @reputation < 0 # Reputation shouldn't go negative
    end
  end
end

class Vote
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end
end

class Comment
  attr_reader :id, :content, :author, :created_at

  def initialize(id, content, author)
    @id = id
    @content = content
    @author = author
    @created_at = Time.now
  end
end

class Tag
  attr_reader :id, :name

  def initialize(id, name)
    @id = id
    @name = name.downcase
  end
end

class Answer
  include Votable
  include Commentable

  attr_reader :id, :content, :author, :question, :created_at

  def initialize(id, content, author, question)
    @id = id
    @content = content
    @author = author
    @question = question
    @created_at = Time.now
    initialize_votable
    initialize_commentable
  end
end

class Question
  include Votable
  include Commentable

  attr_reader :id, :title, :content, :author, :tags, :answers, :created_at

  def initialize(id, title, content, author, tags = [])
    @id = id
    @title = title
    @content = content
    @author = author
    @tags = tags
    @answers = []
    @created_at = Time.now
    initialize_votable
    initialize_commentable
  end

  def add_answer(answer)
    @answers << answer
  end
end

class StackOverflow
  def initialize
    @users = {}
    @questions = {}
    @tags = {}
    
    # Thread safety locks
    @users_mutex = Mutex.new
    @questions_mutex = Mutex.new
    @tags_mutex = Mutex.new
  end

  # --- User Management ---
  def create_user(username, email)
    @users_mutex.synchronize do
      id = @users.size + 1
      user = User.new(id, username, email)
      @users[id] = user
      user
    end
  end

  # --- Question & Tag Management ---
  def post_question(title, content, author, tag_names)
    tags = tag_names.map { |name| find_or_create_tag(name) }
    
    @questions_mutex.synchronize do
      id = @questions.size + 1
      question = Question.new(id, title, content, author, tags)
      @questions[id] = question
      question
    end
  end

  def find_or_create_tag(name)
    @tags_mutex.synchronize do
      normalized_name = name.downcase
      @tags[normalized_name] ||= Tag.new(@tags.size + 1, normalized_name)
    end
  end

  # --- Answer & Comment Actions ---
  def post_answer(question, content, author)
    # Stack Overflow rules dictate answers are bound to a single question instance
    id = rand(1..100000) # Simplified ID generation for demo
    answer = Answer.new(id, content, author, question)
    question.add_answer(answer)
    author.update_reputation(2) # Minor reward for answering
    answer
  end

  def add_comment(target, content, author)
    id = rand(1..100000)
    comment = Comment.new(id, content, author)
    target.add_comment(comment)
    comment
  end

  # --- Voting System ---
  def vote(target, user, value)
    vote = Vote.new(user, value)
    target.add_vote(vote)
  end

  # --- Multi-Criteria Search Engine ---
  def search(query: nil, tag: nil, user: nil)
    results = @questions.values

    if query
      downloader = query.downcase
      results = results.select do |q| 
        q.title.downcase.include?(downloader) || q.content.downcase.include?(downloader)
      end
    end

    if tag
      results = results.select { |q| q.tags.any? { |t| t.name == tag.downcase } }
    end

    if user
      results = results.select { |q| q.author.id == user.id }
    end

    results
  end
end