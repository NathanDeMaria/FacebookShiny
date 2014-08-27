
# packages ####
library(RJSONIO)
library(lubridate)
library(stringr)
library(ggvis)
library(data.table)
library(httr)

source('../R/parsing.R')
source('../R/data_gathering.R')
source('../R/scoring.R')
source('../R/visualize.R')
source('../R/likes.R')
source('../R/appSettings.R')


# takes in a named list of things to put in tabs
bootstrap_tabs <- function(tab_list) {
  begin <- 
    '<div>
      <ul id="myTab" class="nav nav-tabs">'
  
  if(any(names(tab_list) == '')) {
    stop('All items in the list must be named')
  }
  
  active_tab <- paste0('<li class="active"><a href="#', 
                       names(tab_list)[1], 
                       '" data-toggle="tab">', 
                       names(tab_list)[1], 
                       '</a></li>')
  other_tabs <- sapply(names(tab_list)[-1], function(name) {
    paste0('<li><a href="#', name, 
           '" data-toggle="tab">', name, 
           '</a></li>')
  })
  
  tabs <- paste0(c(active_tab, other_tabs), collapse='\n')
  
  
  middle <- '
        </ul>
        <div id="myTabContent" class="tab-content">'
  
  active_content <- paste0('<div class="tab-pane active" id="', 
                           names(tab_list)[1], '">',
                           tab_list[[1]], '</div>')
  
  other_content <- mapply(function(name, tab_content) {
    paste0('<div class="tab-pane" id="', name, '">',
           tab_content,
           '</div>')
  }, names(tab_list[-1]), tab_list[-1])
  
  content <- paste0(c(active_content, other_content), collapse='\n')
  
  end <- '
      </div>
  </div>'
  
  HTML(paste0(c(begin, tabs, middle, content, end), collapse='\n'))
}

create_d3 <- function(like_counts) {
  paste0('
<script>
         var w = 800,
         h = 800,
         radius = 9;
         
         var lineColor = "#ddd";
         
         d3.select("#container")
         .style("width", w + "px")
         .style("height", h + "px");
         
         var vis = d3.select("#container").append("svg:svg")
         .attr("width", w)
         .attr("height", h);
         
         var data = ', 
         d3_force_likes(like_counts),
         ';
         
         
         var force = self.force = d3.layout.force()
         .nodes(data.nodes)
         .links(data.links)
         .linkDistance(function(d) { return (d.distance*300); })
         .charge(-1000)
         .size([w, h])
         .start();
         
         
         var link = vis.selectAll("line.link")
         .data(data.links)
         .enter().append("svg:line")
         .attr("x1", function(d) { return d.source.x; })
         .attr("y1", function(d) { return d.source.y; })
         .attr("x2", function(d) { return d.target.x; })
         .attr("y2", function(d) { return d.target.y; })
         .style("stroke", lineColor);
         
         
         var node = vis.selectAll("g.node")
         .data(data.nodes)
         .enter().append("svg:g")
         .attr("class", "node")
         .call(force.drag);
         
         
         node.append("circle")
         .attr("r", radius)
         .attr("fill", "lightblue");
         
         
         node.append("text")
         .attr("dx", 0)
         .attr("dy", ".35em")
         .style("font-size","10px")
         .attr("text-anchor", "middle")
         .style("fill", "black")
         .text(function(d) { return d.name });
         
         node.on("mouseover", fade(.2,"red"))
         .on("mouseout", fade(1,lineColor));
         
         var linkedByIndex = {};
         data.links.forEach(function(d) {
         linkedByIndex[d.source.index + "," + d.target.index] = 1;
         });
         
         function isConnected(a, b) {
         return linkedByIndex[a.index + "," + b.index] || linkedByIndex[b.index + "," + a.index] || a.index == b.index;
         }
         
         force.on("tick", function() {
         link.attr("x1", function(d) {
         if (d.source.x < radius) {
         return radius;
         } else if(d.source.x > w - radius) {
         return w - radius;
         }
         
         return d.source.x; 
         })
         .attr("y1", function(d) {
         if (d.source.y < radius) {
         return radius;
         } else if(d.source.y > h - radius) {
         return h - radius;
         }
         
         return d.source.y;
         })
         .attr("x2", function(d) { 
         if (d.target.x < radius) {
         return radius;
         } else if(d.target.x > w - radius) {
         return w - radius;
         }
         
         return d.target.x; 
         })
         .attr("y2", function(d) { 
         if (d.target.y < radius) {
         return radius;
         } else if(d.target.y > h - radius) {
         return h - radius;
         }
         
         return d.target.y; 
         });
         
         node.attr("transform", function(d) { 
         var tmp_x = d.x;
         var tmp_y = d.y;
         
         if(tmp_y < radius) {
         tmp_y = radius;
         } else if(tmp_y > h - radius) {
         tmp_y = h - radius;
         }
         
         if(tmp_x < radius) {
         tmp_x = radius;
         } else if(tmp_x > w - radius) {
         tmp_x = w - radius;
         }
         
         return "translate(" + tmp_x + "," + tmp_y + ")"; 
         });
         });
         
         function fade(opacity,color) {
         return function(d) {
         
         node.style("stroke-opacity", function(o) {
         thisOpacity = isConnected(d, o) ? 1 : opacity;
         this.setAttribute(\'fill-opacity\', thisOpacity);
      return thisOpacity;
      });
      
      
      link.style("stroke-opacity", function(o) {
      return o.source === d || o.target === d ? 1 : opacity;
      });
      link.style("stroke", function(o) {
      return o.source === d || o.target === d ? color : lineColor ;
      });
      };
      
      }
      </script>
      ')
}
