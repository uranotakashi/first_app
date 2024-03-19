アプリを作成するディレクトリに移動する。

ターミナル
1
% cd ~/projects
新しいRailsアプリケーションを作成する。

ターミナル
1
% rails _7.0.0_ new first_app -d mysql
作成したアプリケーションのディレクトリに移動する。

ターミナル
1
% cd first_app
2. データベースを作成する
データベース作成のコマンドを実行する。

ターミナル
1
% rails db:create
2. 一覧機能を実装する
1. コントローラーの作成および設定
postsコントローラーを作成する。

ターミナル
1
% rails g controller posts
コントローラーの設定を行う（indexアクション）。

app/controllers/posts_controller.rb
1
2
3
4
5
class PostsController < ApplicationController
  def index
    @posts = Post.all 
  end
end
2. ルーティングの設定
postsコントローラーのindexアクションを呼び出すルーティングを設定する。

config/routes.rb
1
2
3
Rails.application.routes.draw do
 get 'posts', to: 'posts#index'
end
3. モデルの作成
Postモデルを作成する。

ターミナル
1
% rails g model post
contentカラムを追加するため、マイグレーションファイルを編集する。

db/migrate/20XXXXXXXXXXXX_create_posts.rb
1
2
3
4
5
6
7
8
class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :content
      t.timestamps
    end
  end
end
マイグレートを実行する。

ターミナル
1
% rails db:migrate
4. ビューの作成
app/views/postsフォルダにindex.html.erbファイルを作成し、以下のコードをコピーする。

app/views/posts/index.html.erb
 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
<h1>トップページ</h1>
<% @posts.each do |post| %>
  <div class="post">
    <div class="post-date">
      投稿日時：<%= post.created_at %>
    </div>
    <div class="post-content">
      <%= post.content %>
    </div>
  </div>
<% end %>
app/assets/stylesheets/posts.css
1
2
3
4
5
6
7
8
9
.post{
  border: 1px solid;
  width: 40%;
  margin-top: 30px;
}

.post-date{
  color: gray;
}
3. 投稿画面を作成する
1. コントローラーの設定を行う（newアクション）。
app/controllers/posts_controller.rb
1
2
3
4
5
6
7
8
class PostsController < ApplicationController
  def index
    @posts = Post.all 
  end

  def new
  end
end
2. ルーティングの設定
postsコントローラーのnewアクションを呼び出すルーティングを設定する。

config/routes.rb
1
2
3
4
Rails.application.routes.draw do
  get 'posts', to: 'posts#index'
  get 'posts/new', to: 'posts#new'
end
3. ビューの作成
app/views/postsフォルダにnew.html.erbファイルを作成し、以下のコードをコピーする。

app/views/posts/new.html.erb
1
2
3
4
5
6
<h1>新規投稿ページ</h1>

<%= form_with url: "/posts", method: :post, local: true do |form| %>
  <%= form.text_field :content %>
  <%= form.submit '投稿する' %>
<% end %>
一覧ページに投稿ページへのリンクを追加する。

app/views/posts/index.html.erb
 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
13
<h1>トップページ</h1>
<%= link_to '新規投稿', '/posts/new' %>

<% @posts.each do |post| %>
  <div class="post">
    <div class="post-date">
      投稿日時：<%= post.created_at %>
    </div>
    <div class="post-content">
      <%= post.content %>
    </div>
  </div>
<% end %>
4. 保存機能を実装する
1. コントローラーの設定
コントローラーの設定を行う（createアクション）。

app/controllers/posts_controller.rb
 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
class PostsController < ApplicationController
  def index
    @posts = Post.all 
  end

  def new
  end

  def create
    Post.create(content: params[:content])
  end
end
2. ルーティングの設定
postsコントローラーのcreateアクションを呼び出すルーティングを設定する。

config/routes.rb
1
2
3
4
5
Rails.application.routes.draw do
  get 'posts', to: 'posts#index'
  get 'posts/new', to: 'posts#new'
  post 'posts', to: 'posts#create'
end
3. 一覧画面の表示
投稿の保存を行ったら、一覧画面に移動するようredirect_toを設定する。

app/controllers/posts_controller.rb
 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
13
class PostsController < ApplicationController
  def index
    @posts = Post.all 
  end

  def new
  end

  def create
    Post.create(content: params[:content])
    redirect_to "/posts"
  end
end
解説