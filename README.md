# juicv | LaTeX class for compact CVs and cover letters

The class is loosely inspired by the [AltaCV](https://github.com/liantze/AltaCV) class, though it has
diverged so significantly that none of the original code remains.
It has been completely reworked to align with my standards for both
visual and code aesthetics. Most optional features and customization
points have been removed to simplify the code, as they added complexity
without fully meeting my needs. The result is a streamlined,
non-customizable class. If you require more flexibility, the best
approach would be to fork the project and develop your own version.
The following CV has been compiled from the [examples/igrmk-net.tex](examples/igrmk-net.tex) file.

![CV](https://github.com/igrmk/juicv/releases/latest/download/example-igrmk-net.png)

## Build Your Own CV

1. Install your favourite TeX distribution, for example, on macOS using Homebrew:

   ~~~bash
   brew install basictex
   ~~~

2. Clone the repo

3. Rename one of the examples to, say, `john.doe.tex`.
   You might also want to remove the other files to avoid distractions

4. Customize the file to match your experience.
   Don’t forget to update the identifier.

5. Run the following command to compile the CV:

   ~~~bash
   ./scripts/build -s john.doe
   ~~~

## Test Your CV

1. We don't fully understand how Applicant Tracking Systems (ATS) work, but
   it’s clear that the first step is for them to correctly parse your CV.
   In PDFs created by \*TeX flavors, spaces are not explicitly encoded in the
   text. As a result, PDF parsers and viewers must use heuristics to determine
   where spaces should be.

   For instance, a parser like `mutool` handles this perfectly, while macOS
   Preview often struggles with accurately defining word, paragraph, and
   column boundaries. Obviously, ATSs can encounter the same problems.

   To test this, I recommend copying the text from your PDF using multiple
   PDF viewers and pasting it into a text editor to verify accuracy. You may
   find that some lines are merged without spaces. If this happens, try
   rephrasing those lines. Unfortunately, there is no reliable way in LaTeX
   to completely prevent this issue.

   You can also use tools like `mutool` to verify proper parsing:

   ~~~bash
   mutool draw -F text -o john.doe.txt john.doe.pdf
   ~~~

2. To evaluate your CV, you can use services like [Resume Worded](https://resumeworded.com/).
   While some of their suggestions may seem extreme — such as recommending numbers
   in every bullet point or using overly long, AI-generated phrases — the service
   is generally useful overall.

## Cover Letters

This class also allows you to typeset a cover letter.
The following example was compiled from the
[examples/igrmk-cover-letter.tex](examples/igrmk-cover-letter.tex) file.

![Cover Letter](https://github.com/igrmk/juicv/releases/latest/download/example-igrmk-cover-letter.png)

## Internals

1. Vector icons were chosen over Font Awesome
   because the font renders icons as Unicode characters in PDFs,
   which appear as random symbols of standard fonts when copied.
   This can cause issues with Applicant Tracking Systems (ATS).
   Instead, the required SVG icons were downloaded from their website,
   placed in the `graphics` directory, and converted to PDF using the following commands.
   The second command, while not strictly necessary,
   converts PDF 1.7 to PDF 1.4 to prevent a warning.

   ~~~bash
   cairosvg icon.svg -o icon.pdf
   gs -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=icon-compat.pdf icon.pdf
   ~~~

2. Below is a visual explanation of how LaTeX section margins function in different contexts.
   In the figure, if A is positioned above B, it reflects their arrangement in the text.
   The arrow from A to B indicates that A contributes its margin to the distance between A and B.
   There are some nuances for consecutive section titles.
   Instead of implementing this myself,
   I used the LaTeX `@startsection` macro, which already includes this functionality.

   ~~~mermaid
   graph TD;
       ContentBefore1(Content Before) --> Section1(Section Title);
       Section1 --> ContentBefore1;

       SectionBefore2(Section Title Before) --> SectionAfter2(Section Title After);

       Section3(Section Title) --> ContentAfter3(Content After);
       ContentAfter3(Content After) --> Section3;
   ~~~

   Since events in the CV can exist without any content,
   I created a special event without content by copying the paragraph hook code from `ltsect.dtx`
   to make LaTeX recognize the event (which is a subsection) as having content.

3. The vertical spacing of headings appears
   to depend heavily on justification settings
   (e.g., whether the heading is typeset as ragged or justified).
   I chose to always typeset headings as ragged-right,
   as this generally makes more sense for headings
   and results in more compact vertical spacing.
   If a heading needs to be typeset as justified,
   various spacing adjustments are required.

4. Yeah, LaTeX, bitch. This is LaTeX, and that means it has to be painful.
   PDFs, such as CVs, usually embed all the necessary data, like fonts and images.
   This ensures they display exactly as created on any PDF viewer and operating system.

   Images need a color profile to be reproduced accurately.
   The `pdfx` package embeds the `sRGB.icc` color profile into your PDF for this purpose,
   sourced from the [colorprofiles](https://ctan.org/pkg/colorprofiles) package.
   For more details, see the [pdfx package documentation](https://mirrors.ctan.org/macros/latex/contrib/pdfx/pdfx.pdf).

   Unfortunately, Tectonic — which I previously used — doesn’t fully support the
   `pdfx` package. This results in an ill-formatted color profile being embedded in
   your CV. See [this issue](https://github.com/tectonic-typesetting/tectonic/issues/838)
   for more details.

   To fix this, I had to switch to vanilla `XeTeX`. Otherwise, most PDF viewers
   will open your CV, but Adobe Acrobat Reader, for instance, will not.
   So, never use Tectonic for your CV.

5. PDF metadata is stored in two different places within PDF files. And I have no idea why.

   I’ve never been able to specify `\Keywords` in a way that prevents
   `verapdf` from complaining about a mismatch between the two copies of this metadata.
   So, just don’t specify it. It looks like it simply doesn’t work well.

   Maybe the reason is this:
   According to the [pdfx package documentation](https://mirrors.ctan.org/macros/latex/contrib/pdfx/pdfx.pdf),
   metadata specified by the `\Keywords` attribute is written to the `dc:subject` key,
   while `\Subject` is written to `dc:description`.
   What the fuck?! Or could it just be a documentation bug?

6. There isn’t a proper package manager for LaTeX
   that can reliably reproduce the build environment.
   To address this, I vendored all the packages I could.
   However, some are OS- and architecture-specific,
   so they still need to be installed for the build process.

7. I had to revert to Inter font version 3.19,
   even though it is 3 years old and the current version is 4.1.
   The issue with the newer version lies in character mapping:
   when extracting text from a PDF, some characters are incorrectly mapped.
