defmodule Isn do
  alias Postgrex.TypeInfo

  @behaviour Postgrex.Extension
  @isn ~w(ean13 isbn13 ismn13 issn13 isbn ismn issn upc)

  @moduledoc """
  A Postgrex.Extension enabling the use of postgresql data types from the isn
  extension.

  Add this module as an extension when establishing your Postgrex connection:

      Postgrex.Connection.start_link(
        database: "isn_test",
        extensions: [{Isn, {}}])

  Then you can do Ecto.Migrations like this:

      defmodule MyApp.Repo.Migrations.CreateBook do
        use Ecto.Migration

        def change do
          create table(:books) do
            add :isbn, :isbn13
            # other fields
          end
        end
      end

  You can also define Ecto.Models using the matching custom Ecto.Types:

      defmodule MyApp.Book do
        use MyApp.Web, :model

        schema "books" do
          field :isbn, Isn.ISBN13
          # other fields
        end
      end
  """

  def init(parameters, _opts),
    do: parameters

  def matching(_library),
    do: Enum.zip(Stream.cycle([:type]), @isn)

  def format(_),
    do: :text

  def encode(%TypeInfo{type: type}, binary, _types, _opts) when type in @isn,
    do: binary

  def decode(%TypeInfo{type: type}, binary, _types, _opts) when type in @isn,
    do: binary
end

defmodule Isn.Base do
  @moduledoc """
  Base module for Isn custom ecto types.
  """

  @doc """
  Set up basic functionality for an Isn type.

  This extends the calling module by defining implementations for

  * type/0
  * blank?/0
  * cast/1
  * load/1
  * dump/1
  """
  defmacro __using__(_opts) do
    ecto_type = __CALLER__.module
                |> Atom.to_string
                |> String.replace(~r(.+\.), "")
    isn_type = ecto_type
               |> String.downcase
               |> String.to_atom

    quote bind_quoted: [isn_type: isn_type, ecto_type: ecto_type] do
      @behaviour Ecto.Type

      @moduledoc """
      Definition for the #{isn_type} module.

      How to use this in an Ecto.Model

          defmodule MyApp.Book do
            use MyApp.Web, :model

            schema "books" do
              field :#{isn_type}, Isn.#{ecto_type}
              # other fields
            end
          end
      """

      def type, do: unquote(isn_type)

      defdelegate blank?, to: Ecto.Type

      def cast(nil), do: :error
      def cast(isn), do: {:ok, to_string(isn)}

      def load(isn), do: {:ok, to_string(isn)}

      def dump(isn), do: {:ok, to_string(isn)}
    end
  end
end

defmodule Isn.ISBN,   do: use(Isn.Base)
defmodule Isn.ISMN,   do: use(Isn.Base)
defmodule Isn.ISSN,   do: use(Isn.Base)
defmodule Isn.ISBN13, do: use(Isn.Base)
defmodule Isn.ISMN13, do: use(Isn.Base)
defmodule Isn.ISSN13, do: use(Isn.Base)
defmodule Isn.UPC,    do: use(Isn.Base)
defmodule Isn.EAN13,  do: use(Isn.Base)
