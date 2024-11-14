\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{juicv}[2024/11/14 v2.0.8 LaTeX CV class focused on compactness]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions\relax
\LoadClass{extarticle}

\RequirePackage[a-1b]{pdfx}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage{fontspec}
\RequirePackage{tikz}
\RequirePackage[skins]{tcolorbox} % Needed for `fill overzoom image` feature
\RequirePackage[inline]{enumitem}
\RequirePackage{needspace}
\RequirePackage{etoolbox}
\RequirePackage[newcommands]{ragged2e}

\usetikzlibrary{arrows}

\linespread{1.18}
\sloppy
\pagestyle{empty}
\setlist{
    leftmargin=*,
    labelsep=0.5em,
    nosep,
    itemsep=0.15\baselineskip,
    after=\vspace{0.2\baselineskip}
}
\setlist[itemize]{label={\small\textbullet}}
\setlength{\parindent}{0pt}
\pagenumbering{gobble}
\newlength{\normalToNormalSpacingAdjustment}
\setlength{\normalToNormalSpacingAdjustment}{2.8pt}
\newlength{\normalToSmallSpacingAdjustment}
\setlength{\normalToSmallSpacingAdjustment}{2pt}
\newlength{\smallToSmallSpacingAdjustment}
\setlength{\smallToSmallSpacingAdjustment}{1.3pt}

\definecolor{secondaryTextColor}{RGB}{115, 115, 115}
\colorlet{secondaryTextColor}{secondaryTextColor}
\definecolor{accentColor}{RGB}{40, 102, 225}
\colorlet{accentColor}{accentColor}
\definecolor{outlineColor}{RGB}{213, 213, 213}
\colorlet{outlineColor}{outlineColor}
\newcommand{\cvPersonIcon}{\raisebox{-0.1pt}{\includegraphics[height=7.5pt]{graphics/user-solid-compat.pdf}}}
\newcommand{\cvExperienceIcon}{\raisebox{-0.5pt}{\includegraphics[height=7.5pt]{graphics/briefcase-solid-compat.pdf}}}
\newcommand{\cvRatingMarker}{}
\newcommand{\cvMarkerSpacing}{}
\newcommand{\cvSetRating}[2]{%
    \renewcommand{\cvRatingMarker}{#1}
    \renewcommand{\cvMarkerSpacing}{#2}
}

\cvSetRating
    {\raisebox{1.7pt}{\tikz \fill[rounded corners=1pt] (0,0) rectangle (4.9pt, 2.4pt);}}
    {1.5pt}

\newcommand{\cvMakeHeader}[3]{%
    \def\name{#1}
    \def\photo{#2}
    \def\tagline{#3}
    \begingroup
        \begin{minipage}{1.5cm}%
            \tikz
            \path[rounded corners=0.3cm, fill overzoom image={\photo}]rectangle(1.5cm, 1.5cm);
        \end{minipage}%
        \hspace{0.5cm}%
        \begin{minipage}{\dimexpr\linewidth-2cm}%
            \raggedright%
            {%
                \LARGE%
                \bfseries%
                \name%
                \par%
            }%
            \vspace{1.5pt}
            {%
                \large
                \tagline
                \par
            }
        \end{minipage}%
        \par%
    \endgroup
    \medskip
}

\newcommand{\cvLeftSection}[2]{%
    \makeatletter
    \@startsection
        {section}
        {1}
        {0pt}
        {7.5pt}
        {3pt}
        {\normalfont\Large\bfseries}
        *{%
            \raggedright%
            #1\hspace{0.16cm}#2
        }%
    \makeatother
}

\newcommand{\cvRightSection}[1]{%
    \makeatletter
    \@startsection
        {section}
        {1}
        {0pt}
        {7pt}
        {2.5pt}
        {\normalfont\large\bfseries}
        *{\raggedright#1}
    \makeatother
}

\newcommand{\cvLeftEvent}[5]{%
    \def\title{#1}
    \def\company{#2}
    \def\date{#3}
    \def\location{#4}
    \def\link{#5}
    \Needspace{3\baselineskip}
    \makeatletter
    \@startsection
        {subsection}
        {2}
        {0pt}
        {4.5pt}
        {2pt}
        {\normalfont\normalsize}
        *{%
            \raggedright%
            \textbf{\title}%
            \color{secondaryTextColor}
            \ifx\company\empty
                \ifx\location\empty
                \else
                    \hspace{3pt}in \location
                \fi
            \else
                \hspace{3pt}at \company
                \ifx\location\empty
                \else
                    , \location
                \fi
            \fi
            \ifx\date\empty
                \ifx\link\empty
                \else
                    \\[\normalToSmallSpacingAdjustment]
                \fi
            \else
                \\[\normalToSmallSpacingAdjustment]
            \fi
            \small
            \ifx\date\empty
            \else
                \date
            \fi
            \ifx\link\empty
            \else
                \ifx\date\empty
                \else
                    \\[\smallToSmallSpacingAdjustment]
                \fi
                \link
            \fi
        }%
    \makeatother
}

\newcommand{\cvRightEvent}[5]{%
    \def\title{#1}
    \def\company{#2}
    \def\date{#3}
    \def\location{#4}
    \def\link{#5}

    \makeatletter
    \@startsection
        {subsection}
        {2}
        {0pt}
        {4.5pt}
        {2pt}
        {\normalfont\normalsize}
        *{%
            \raggedright%
            \title
            \ifx\company\empty
                \ifx\location\empty
                    \ifx\date\empty
                    \else
                        \\[\normalToNormalSpacingAdjustment]
                    \fi
                \else
                    \\[\normalToNormalSpacingAdjustment]
                \fi
            \else
                \\[\normalToNormalSpacingAdjustment]
            \fi
            \color{secondaryTextColor}
            \ifx\company\empty
            \else
                \company
            \fi
            \ifx\location\empty
            \else
                \ifx\company\empty
                \else
                    ,
                \fi
                \location
            \fi
            \small
            \ifx\date\empty
            \else
                \\[\normalToSmallSpacingAdjustment]
                \date
            \fi
            \ifx\link\empty
            \else
                \ifx\date\empty
                \else
                    \\[\smallToSmallSpacingAdjustment]
                \fi
                \link
            \fi
        }%
    \makeatother
}

\newcommand{\cvRightEventNoBody}[5]{%
    \cvRightEvent{#1}{#2}{#3}{#4}{#5}
    \@nobreakfalse
    \if@afterindent \else
        {\setbox\z@\lastbox}%
    \fi
}

\newcommand{\cvTag}[1]{%
    \mbox{%
        \color{secondaryTextColor}#1%
        \color{white},%
    }%
    \hspace{2.6pt}%
}

\newcommand{\cvSkill}[2]{%
    #1\hfill
    \foreach \x in {1,...,5}{%
        {%
            \ifnum \x > #2
                \color{outlineColor!60}%
            \else
                \color{accentColor}%
            \fi
            \cvRatingMarker%
            \hspace{\cvMarkerSpacing}%
        }%
    }%
    \par%
}
