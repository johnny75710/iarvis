# COPILOT.md — Guía explícita para Copilot (Elixir + Phoenix API)

> Este archivo define reglas **claras, explícitas y ejemplificadas** para que GitHub Copilot genere siempre código idiomático, mantenible y consistente en este proyecto Phoenix API-only (con `--binary-id`).

---

## 1. Principios básicos

1. **Contexts primero**: toda la lógica de negocio va en módulos de contexto, nunca en los controladores.
2. **Schemas con binary_id**: todos los IDs son UUID (`:binary_id`).
3. **Changesets para validar**: validaciones y constraints se hacen en el changeset y migración.
4. **Controllers delgados**: no deben contener lógica, solo delegar a contexts y renderizar resultados.
5. **Views controlan JSON**: nunca devolver `Map.from_struct/1` completo, solo campos explícitos.
6. **Errores centralizados**: usar `action_fallback` y `FallbackController` para manejar errores de forma uniforme.
7. **Tests obligatorios**: siempre incluir ejemplos de tests de contexto y de controller.

---

## 2. Migraciones (ejemplo con binary_id)

```elixir
defmodule MyApp.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :slug, :string, null: false
      add :content, :text, null: false
      add :excerpt, :text
      add :featured_image, :string
      add :author_name, :string, null: false
      add :author_email, :string
      add :status, :string, null: false, default: "draft"
      add :is_featured, :boolean, default: false
      add :view_count, :integer, default: 0
      add :published_at, :utc_datetime
      add :category_id, references(:categories, type: :binary_id, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:posts, [:slug])
    create index(:posts, [:category_id])
  end
end
```

**Regla para Copilot**: *todas las migraciones deben usar `:binary_id`.*

---

## 3. Schemas & Changesets

```elixir
defmodule MyApp.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :title, :string
    field :slug, :string
    field :content, :string
    field :excerpt, :string
    field :featured_image, :string
    field :author_name, :string
    field :author_email, :string
    field :status, :string, default: "draft"
    field :is_featured, :boolean, default: false
    field :view_count, :integer, default: 0
    field :published_at, :utc_datetime

    belongs_to :category, MyApp.Blog.Category
    has_many :comments, MyApp.Blog.Comment

    timestamps()
  end

  @required ~w(title slug content author_name status)a
  @optional ~w(excerpt featured_image author_email is_featured view_count published_at category_id)a

  def changeset(post, attrs) do
    post
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:title, min: 3)
    |> unique_constraint(:slug)
    |> foreign_key_constraint(:category_id)
  end
end
```

**Regla para Copilot**: *usar `@primary_key {:id, :binary_id, autogenerate: true}` y `@foreign_key_type :binary_id` siempre.*

---

## 4. Contexts (ejemplo CRUD)

```elixir
defmodule MyApp.Blog do
  import Ecto.Query, warn: false
  alias MyApp.Repo
  alias MyApp.Blog.Post

  def list_posts do
    Repo.all(from p in Post, order_by: [desc: p.inserted_at])
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end
end
```

**Regla para Copilot**: *Contexts exponen funciones `list_*, get_*!/1, create_*/1, update_*/2, delete_*/1`. Nunca lógica de JSON ni de HTTP.*

---

## 5. Controllers & Views

**Controller con `action_fallback`:**

```elixir
defmodule MyAppWeb.PostController do
  use MyAppWeb, :controller
  alias MyApp.Blog

  action_fallback MyAppWeb.FallbackController

  def index(conn, _params) do
    posts = Blog.list_posts()
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    with {:ok, post} <- Blog.create_post(post_params) do
      conn
      |> put_status(:created)
      |> render("show.json", post: post)
    end
  end
end
```

**View controlando el JSON:**

```elixir
defmodule MyAppWeb.PostView do
  use MyAppWeb, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, __MODULE__, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, __MODULE__, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      slug: post.slug,
      content: post.content,
      published_at: post.published_at
    }
  end
end
```

**Regla para Copilot**: *serializar siempre con Views y `render_one`/`render_many`.*

---

## 6. Errores & Fallback

**Regla para Copilot**: *usar FallbackController y devolver status 422 para changesets y 404 para not found.*

---

## 7. Tests (ejemplo mínimo)

```elixir
defmodule MyApp.BlogTest do
  use MyApp.DataCase, async: true
  alias MyApp.Blog

  @valid_attrs %{title: "Hello", slug: "hello", content: "World", author_name: "Admin", status: "draft"}
  @invalid_attrs %{title: nil}

  test "create_post/1 with valid data creates a post" do
    assert {:ok, post} = Blog.create_post(@valid_attrs)
    assert post.title == "Hello"
  end

  test "create_post/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
  end
end
```

**Regla para Copilot**: *cada context debe tener tests de validación CRUD. Cada controller debe tener tests de status y renderizado JSON.*

---

## 8. Instrucciones personalizadas para Copilot Chat

```
- Siempre asume que trabajas en una API Phoenix-only con binary_id (--binary-id).
- Usa naming idiomático Phoenix/Ecto.
- Contexts exponen funciones CRUD (list/get/create/update/delete).
- Validaciones en Changesets, constraints en DB.
- Controllers delgados, Views para JSON, action_fallback para errores.
- Generar código compatible con mix format y credo.
- Separar el código usando la arquitectura Functional Core - Imperative Shell, de modo que en los módulos de contexto sólo debe de haber código Imperative Shell I/O y separar la lógica pura en otros módulos según sea conveniente.
- Siempre especificar los @type y @spec necesarios para proporcionar una API clara y transparente al desarrollador sobre el código. 
- Siempre incluir tests básicos.
- Nunca añadir autenticación ni usuarios salvo que se pida.
```

---

## 9. Checklist rápida

- [ ] Migraciones usan binary_id correctamente.  
- [ ] Schemas con `@primary_key {:id, :binary_id, autogenerate: true}`.  
- [ ] Context con funciones CRUD idiomáticas.  
- [ ] Controllers delgados con fallback.  
- [ ] Views controlan JSON.  
- [ ] Tests de contexto + controller.  
- [ ] Código pasa `mix format` y `credo`.  

---

**Nota final:** Copilot debe seguir siempre estos ejemplos como referencia. No inventar patrones distintos salvo que sea necesario para el correcto desarrollo. Debe usar siempre buenas prácticas y siempre buscar información sobre las novedades o sintaxis que deba usar.