defmodule Issues.CLI do
    @default_count 4

    @moduledoc """
    Handle the command line pardsing and the dispatch to
    the various functions that end up generating a 
    table of the last _n_ issues in a githut project
    """

    def run(argv) do
        argv
        |> parse_args
        |> process
    end
    
    @doc """
    `argv` can be -h or --help, which return :help.
    """
    def parse_args(argv) do
      parse = OptionParser.parse(argv, switches: [help: :boolean],
                                       alias:   [h:     :help])
        case parse do
          { [help: true ], _, _}
            -> :help
          {_, [user, project, count ], _} 
            ->{user, project, String.to_integer count}                                              
          {_, [user, project], _}
            ->{user, project, @default_count}
    
          _ -> :help
        end
    end

    def process(:help) do
        IO.puts """
        usage: issues <user> <project> [count | #{@default_count}]
        """
        System.halt(0)
    end

    def process({user, project, _count}) do
        Issues.GibhutIssues.fetch(user, project)
    end
end