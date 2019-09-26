defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category
  alias Rumbl.Multimedia.Video

  describe "categories" do
    test "list alphabetical categories/0" do
      for name <- ~w(Drama Action Comedy) do
        Multimedia.create_category!(name)
      end

      alpha_names = for %Category{name: name} <- Multimedia.list_alphabetical_categories() do
        name
      end

      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    @valid_attrs %{description: "desc", title: "title", url: "http://local"}
    @invalid_attrs %{description: nil, title: nil, url: nil}

    test "list_videos/0 returns all videos" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1,}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with the given id" do
      owner = user_fixture()
      %Video{id: id} = video_fixture(owner)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/2 with valid data creates a video" do
      owner = user_fixture()
      assert {:ok, %Video{id: id} = video} = Multimedia.create_video(owner, @valid_attrs)

      IO.inspect video

      assert video.description == "desc"
      assert video.title == "title"
      assert video.url == "http://local"
      assert video.slug == "title"
    end

    test "create_video/2 with invalid data returns error changeset" do
      owner = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      owner = user_fixture()
      video = video_fixture(owner)
      assert {:ok, video} = Multimedia.update_video(video, %{title: "Updated title"})
      assert %Video{} = video
      assert video.title == "Updated title"
    end

    test "update_video/2 with invalid data returns an error changeset" do
      owner = user_fixture()
      video = video_fixture(owner)
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, %{description: nil})
    end

    test "delete_video/1 deletes the video" do
      owner = user_fixture()
      video = video_fixture(owner)
      Multimedia.delete_video(video)
      assert Multimedia.list_videos() == []
    end

    test "change_video/1 returns a video changeset" do
      owner = user_fixture()
      video = video_fixture(owner)

      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end

end
