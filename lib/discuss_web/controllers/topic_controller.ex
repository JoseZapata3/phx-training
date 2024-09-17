defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.{Repo, Topic}

  def home(conn, _params) do
    topics = Repo.all(Topic)

    render(conn, "home.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{},%{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    changeset =  Topic.changeset(%Topic{},topic)
    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: "/")
      {:error,   changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
     topic = Repo.get(Topic, topic_id)
     changeset = Topic.changeset(topic)

     render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => new_topic }) do
    topic = Repo.get(Topic, topic_id)
    chageset = Topic.changeset(topic, new_topic)

    case Repo.update(chageset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: "/")
      {:error, chageset} ->
        render(conn, "edit.html", changeset: chageset, topic: topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    Repo.delete!(topic)

    conn
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: "/")
  end

end
