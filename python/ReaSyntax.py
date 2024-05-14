import urllib.request
import re

def get_html(url):
    # Fetch HTML content from the URL
    with urllib.request.urlopen(url) as response:
        html_content = response.read().decode('utf-8')

    return html_content

def extract_code_segments(html_content, language):

    # Construct regular expression to match divs with specified class
    div_regex = r'<div class="{}">.*<code>(.*)</code>.*</div>'.format(language)

    # Find all matches
    div_matches = re.findall(div_regex, html_content)

    cleaning_regex = r'<i>|</i>'
    div_matches = [re.sub(cleaning_regex, '', i) for i in div_matches]

    return div_matches


def transform_function_string(input_str):
    # Split the input string to extract function name and arguments
    parts = input_str.split('(')
    if len(parts) != 2:
        raise ValueError("Invalid function string")

    function_name = parts[0].strip()
    args_str = parts[1].split(')')[0]
    if len(args_str) < 1:
        return input_str

    arguments = [arg.strip() for arg in args_str.split(',')]

    # Format the arguments iteratively
    formatted_args = []
    for i, arg in enumerate(arguments, start=1):
        formatted_arg = "${{{}:{}}}".format(i, arg)
        formatted_args.append(formatted_arg)

    # Join the formatted arguments
    formatted_args_str = ', '.join(formatted_args)

    # Construct the transformed function string
    transformed_str = "{}({})".format(function_name, formatted_args_str)

    return transformed_str

def reascript_to_ultisnips(functions, no_returns):
    ultisnips_snippets = []
    for i in range(len(functions)):
        function = functions[i]
        function_no_return = no_returns[i]

        function_name_regex = r'\.?([\w]+)\(.*$'
        function_name = re.search(function_name_regex, function_no_return).group(1)

        snipped_function = transform_function_string(function_no_return)

        snippet_line_1 = "snippet {} \"{}\"".format(function_name, function)
        snippet = "{}\n{}\nendsnippet".format(snippet_line_1, snipped_function)
        ultisnips_snippets.append(snippet)

    return ultisnips_snippets


def make_ultisnips(language):
    url = "https://www.reaper.fm/sdk/reascript/reascripthelp.html"
    html_content = get_html(url)

    language = '{}_func'.format(language)
    functions = extract_code_segments(html_content, language)

    no_returns_regex = r'\S+\(.*\)'
    no_returns = [re.search(no_returns_regex, function).group(0) for function in functions]

    ultisnips = reascript_to_ultisnips(functions, no_returns)
    return ultisnips

#  test = make_ultisnips("l")
#  for i in test:
    #  print(i)
