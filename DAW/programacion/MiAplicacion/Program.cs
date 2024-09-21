// See https://aka.ms/new-console-template for more information
using System;
using System.Diagnostics;

[DebuggerDisplay($"{{{nameof(GetDebuggerDisplay)}(),nq}}")]
internal class Program
{
    private static void Main(string[] args, Console console)
    {
        console.Write(“Programming...”);
    }

    private string GetDebuggerDisplay()
    {
        return ToString();
    }
}